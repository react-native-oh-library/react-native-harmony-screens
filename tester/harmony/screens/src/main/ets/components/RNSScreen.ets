import { Descriptor, RNComponentContext, RNViewBase, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { CustomTransitionCoordinator } from '../animations/CustomTransition';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview, RNSScreenStackHeaderSubviewDescriptor } from './RNSScreenStackHeaderSubview';
import { window } from '@kit.ArkUI';
import { AnimationHandlerEvent, getNewAnimationState } from '../animations/AnimationHandler';

export type RNSScreenDescriptor = Descriptor<"RNSScreen", RNC.RNSScreen.Props>

const TITLEBAR_HEIGHT = 56;

@Component
struct RNSScreenTitle {
  public ctx!: RNComponentContext
  @Watch('onDescriptorChange') @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor =
    {} as RNSScreenStackHeaderConfigDescriptor
  @State nativeTitleText: string = "";

  aboutToAppear(): void {
    this.onDescriptorChange()
  }

  onDescriptorChange() {
    const shouldDisplayNativeTitle = this.screenStackHeaderConfigDescriptor.childrenTags.length > 0 ?
    this.screenStackHeaderConfigDescriptor.childrenTags.map((e) => {
      const tmpDesc = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(e)
      if (tmpDesc.rawProps["type"] === "title" || tmpDesc.rawProps["type"] === "center" ||
        tmpDesc.rawProps["type"] === "left") {
        return false;
      }
      return true;
    }).every((value) => value === true) : true;
    this.nativeTitleText = shouldDisplayNativeTitle ? this.screenStackHeaderConfigDescriptor.rawProps["title"] : " ";
  }

  build() {
    Stack() {
      Text(this.nativeTitleText)
        .width("100%")
        .height("100%")
        .offset({
          left: TITLEBAR_HEIGHT + 8
        })
        .fontFamily(this.screenStackHeaderConfigDescriptor.rawProps["titleFontFamily"])
        .fontSize(this.screenStackHeaderConfigDescriptor.rawProps["titleFontSize"])
        .fontWeight(this.screenStackHeaderConfigDescriptor.rawProps["titleFontWeight"])
        .fontColor(this.screenStackHeaderConfigDescriptor.rawProps["titleColor"])
        .textAlign(TextAlign.Start)
      ForEach(this.screenStackHeaderConfigDescriptor.childrenTags, (childTag: number) => {
        RNSScreenStackHeaderSubview({
          ctx: this.ctx,
          tag: childTag
        })
      })
    }
    .width("100%")
    .height("100%")
    .hitTestBehavior(HitTestMode.Transparent)
    .offset({
      right: TITLEBAR_HEIGHT
    })
  }
}


@Component
export struct RNSScreen {
  public static readonly NAME = RNC.RNSScreen.NAME
  public ctx!: RNComponentContext
  public isFirstScreenInStack!: boolean
  public customTransitionCoordinator!: CustomTransitionCoordinator
  public tag: number = 0
  private eventEmitter: RNC.RNSScreen.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  private dismissCount: number = 1;
  @State public topInset: number = 0;
  @State descriptor: RNSScreenDescriptor = {} as RNSScreenDescriptor
  @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor =
    {} as RNSScreenStackHeaderConfigDescriptor
  @State titleHeight: number = 0;
  @State presentationMode: NavDestinationMode = NavDestinationMode.STANDARD;
  @State private stackAnimation: string = "";
  private pageId: string = 'default';
  @State backgroundColorValue: string | undefined = undefined
  @State translateXValue: string = '0';
  @State translateYValue: string = '0';
  @State opacityValue: number = 1;

  private isComponentOfType(childTag: number, componentType: string): boolean {
    const descriptor = this.ctx.descriptorRegistry.getDescriptor<Descriptor>(childTag)
    if (descriptor.type === componentType) {
      return true;
    }
    return false;
  }

  handleAnimation(animationType: string, animationEvent: AnimationHandlerEvent): void {
    const newState = getNewAnimationState(animationType, animationEvent)
    if (newState.translateXValue) {
      this.translateXValue = newState.translateXValue;
    }
    if (newState.translateYValue) {
      this.translateYValue = newState.translateYValue
    }
    if (newState.opacityValue) {
      this.opacityValue = newState.opacityValue
    }
  }

  registerAnimation() {
    // Passing the callbacks in the object breaks animateTo
    this.customTransitionCoordinator.registerNavParam(this.pageId,
      () => this.stackAnimation,
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.ATTACH_START),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.ATTACH_END),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.DETACH_START),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.DETACH_END),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.SHOW_START),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.SHOW_END),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.HIDE_START),
      (animationType) => this.handleAnimation(animationType, AnimationHandlerEvent.HIDE_END),
    )
  }

  // Animation region end
  aboutToAppear() {
    this.eventEmitter = new RNC.RNSScreen.EventEmitter(this.ctx.rnInstance, this.tag)

    // RNSScreen
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenDescriptor)
        this.updateState()
      }
    ))

    // RNSScreenStackHeaderConfig
    const screenStackHeaderConfigTag =
      this.descriptor.childrenTags.find((childTag) => this.isComponentOfType(childTag,
        "RNSScreenStackHeaderConfig"))

    if (screenStackHeaderConfigTag) {
      this.screenStackHeaderConfigDescriptor =
        this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderConfigDescriptor>(screenStackHeaderConfigTag)
      this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(screenStackHeaderConfigTag,
        (newDescriptor) => {
          this.screenStackHeaderConfigDescriptor = (newDescriptor as RNSScreenStackHeaderConfigDescriptor)
          this.updateState()
        }
      ))
    }

    this.updateState()
  }

  async updateState() {
    this.updateNativeHeaderHeight()

    this.stackAnimation = this.descriptor.rawProps["stackAnimation"] || "default";

    const presentation: string = this.descriptor.rawProps["stackPresentation"] || "";
    if (["modal", "transparentModal", "containedModal", "containedTransparentModal",
      "fullScreenModal"].includes(presentation)) {
      this.presentationMode = NavDestinationMode.DIALOG;
      this.stackAnimation = 'fade';
    }

    if (presentation.includes("transparent")) {
      this.backgroundColorValue = 'rgba(0,0,0,0)'
    }

    const statusBarStyle: string = this.descriptor.rawProps["statusBarStyle"]
    const statusBarAnimation: boolean = this.descriptor.rawProps["statusBarAnimation"] !== "none";
    const statusBarHidden: boolean = this.descriptor.rawProps["statusBarHidden"]
    let statusBarContentColor: string = "#000000"
    if (statusBarStyle === "light") {
      statusBarContentColor = "#E5FFFFFF"
    }
    const windowInstance = await window.getLastWindow(this.ctx.uiAbilityContext);
    await windowInstance.setSpecificSystemBarEnabled('status', !statusBarHidden);
    windowInstance.setWindowSystemBarProperties({
      statusBarContentColor,
      enableStatusBarAnimation: statusBarAnimation,
    });
  }

  updateNativeHeaderHeight() {
    if (this.screenStackHeaderConfigDescriptor.rawProps["hidden"] ||
      this.presentationMode === NavDestinationMode.DIALOG) {
      this.titleHeight = 0;
    } else if (this.screenStackHeaderConfigDescriptor.rawProps["title"] || !this.isFirstScreenInStack) {
      this.titleHeight = TITLEBAR_HEIGHT
    }

    this.eventEmitter?.emit("headerHeightChange", {
      headerHeight: this.topInset + this.titleHeight
    })
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  @Builder
  screenTitleBuilder() {
    RNSScreenTitle({
      ctx: this.ctx,
      screenStackHeaderConfigDescriptor: this.screenStackHeaderConfigDescriptor
    })
  }

  build() {
    NavDestination() {
      RNViewBase({ ctx: this.ctx, tag: this.tag }) {
        Stack() {
          ContentSlot(this.ctx.getContentForTag(this.tag))
        }.offset({
          top: -this.topInset - this.titleHeight
        })
      }
    }
    .title({ builder: this.screenTitleBuilder, height: this.titleHeight }, {
      backgroundColor: this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"],
    })
    .backgroundColor(this.backgroundColorValue)
    .mode(this.presentationMode)
    .onReady((context: NavDestinationContext) => {
      if (context.navDestinationId) {
        this.pageId = context.navDestinationId;
        this.registerAnimation();
      }
    })
    .translate({ x: this.translateXValue, y: this.translateYValue })
    .opacity(this.opacityValue)
    .hideTitleBar(this.screenStackHeaderConfigDescriptor.rawProps["hidden"] ||
      this.presentationMode === NavDestinationMode.DIALOG)
    .onWillAppear(() => {
      this.eventEmitter!.emit("willAppear", {})
    })
    .onAppear(() => {
      this.eventEmitter!.emit("appear", {})
    })
    .onWillDisappear(() => {
      this.eventEmitter!.emit("willDisappear", {})
    })
    .onDisAppear(() => {
      this.customTransitionCoordinator.unregisterNavParam(this.pageId);
      this.eventEmitter!.emit("disappear", {})
    })
    .onBackPressed(() => {
      this.eventEmitter!.emit("dismissed", {
        dismissCount: this.dismissCount
      })
      return false;
    })
  }
}