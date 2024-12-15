import { ColorValue, Descriptor, RNComponentContext, RNViewBase, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { CustomTransitionCoordinator } from '../animations/CustomTransition';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview, RNSScreenStackHeaderSubviewDescriptor } from './RNSScreenStackHeaderSubview';
import { window } from '@kit.ArkUI';

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
  // Animation region
  private stackAnimation: string = "";
  private pageId: string = '';
  @State backgroundColorValue: string | undefined = undefined
  @State translateXValue: string = '0';
  @State translateYValue: string = '0';
  @State opacityValue: number = 1;
  attachAnimationOptions: AnimateParam = {};
  detachAnimationOptions: AnimateParam = {};
  showAnimationOptions: AnimateParam = {};
  hideAnimationOptions: AnimateParam = {};

  // Animation region end

  private isComponentOfType(childTag: number, componentType: string): boolean {
    const descriptor = this.ctx.descriptorRegistry.getDescriptor<Descriptor>(childTag)
    if (descriptor.type === componentType) {
      return true;
    }
    return false;
  }

  // Animation region
  // TODO: extract those callbacks to a separate class, find a way to update the animation state from the nested class object.
  attachAnimationStartCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
      case 'ios':
        this.translateXValue = '100%';
        break;
      case 'slide_from_left':
        this.translateXValue = '-100%';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "100%"
      case 'fade_from_bottom':
        this.translateYValue = "100%"
        this.opacityValue = 0
      case 'fade':
        this.opacityValue = 0
    }
  }

  attachAnimationEndCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
      case 'ios':
        this.translateXValue = '0';
        break;
      case 'slide_from_left':
        this.translateXValue = '0';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "0"
      case 'fade_from_bottom':
        this.translateYValue = "0"
        this.opacityValue = 1
      case 'fade':
        this.opacityValue = 1
    }
  }

  detachAnimationStartCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
      case 'ios':
        this.translateXValue = '0';
        break;
      case 'slide_from_left':
        this.translateXValue = '0';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "0"
      case 'fade_from_bottom':
        this.translateYValue = "0"
        this.opacityValue = 1
      case 'fade':
        this.opacityValue = 1
    }
  }

  detachAnimationEndCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
      case 'ios':
        this.translateXValue = '100%';
        break;
      case 'slide_from_left':
        this.translateXValue = '-100%';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "100%"
      case 'fade_from_bottom':
        this.translateYValue = "100%"
        this.opacityValue = 0
      case 'fade':
        this.opacityValue = 0
    }
  }

  showAnimationStartCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
        this.translateXValue = '-100%';
        break;
      case 'slide_from_left':
        this.translateXValue = '100%';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "0"
      case 'fade_from_bottom':
        this.translateYValue = "0"
        this.opacityValue = 1
      case 'ios':
        this.translateXValue = '-30%';
      case 'fade':
        this.opacityValue = 1
    }
  }

  showAnimationEndCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
        this.translateXValue = '0';
        break;
      case 'slide_from_left':
        this.translateXValue = '0';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "0"
      case 'fade_from_bottom':
        this.translateYValue = "0"
        this.opacityValue = 1
      case 'ios':
        this.translateXValue = '0%';
      case 'fade':
        this.opacityValue = 1
    }
  }

  hideAnimationStartCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
        this.translateXValue = '0';
        break;
      case 'slide_from_left':
        this.translateXValue = '0';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "0"
      case 'fade_from_bottom':
        this.translateYValue = "0"
        this.opacityValue = 1
      case 'ios':
        this.translateXValue = '0';
      case 'fade':
        this.opacityValue = 1
    }
  }

  hideAnimationEndCallback(animationType: string): void {
    switch (animationType) {
      case 'slide_from_right':
        this.translateXValue = '-100%';
        break;
      case 'slide_from_left':
        this.translateXValue = '100%';
        break;
      case 'slide_from_bottom':
        this.translateYValue = "0"
      case 'fade_from_bottom':
        this.translateYValue = "0"
        this.opacityValue = 1
      case 'ios':
        this.translateXValue = '-30%';
      case 'fade':
        this.opacityValue = 1
    }
  }

  registerAnimation() {
    switch (this.stackAnimation) {
      case 'slide_from_right':
      case 'slide_from_left':
      case 'slide_from_bottom':
      case 'fade_from_bottom':
        this.attachAnimationOptions = {
          duration: 400
        }
        this.detachAnimationOptions = {
          duration: 400
        }
        this.hideAnimationOptions = {
          duration: 400
        }
        this.showAnimationOptions = {
          duration: 400
        }
        break;
      case 'ios':
        this.attachAnimationOptions = {
          duration: 200,
          curve: Curve.Friction
        }
        this.detachAnimationOptions = {
          duration: 200,
          curve: Curve.Friction
        }
        this.hideAnimationOptions = {
          duration: 200,
          curve: Curve.Friction
        }
        this.showAnimationOptions = {
          duration: 200,
          curve: Curve.Friction
        }
        break;
      case 'fade':
        this.attachAnimationOptions = {
          duration: 150,
        }
        this.detachAnimationOptions = {
          duration: 150,
        }
        this.hideAnimationOptions = {
          duration: 150,
        }
        this.showAnimationOptions = {
          duration: 150,
        }
        break;
      case 'none':
        this.attachAnimationOptions = {
          duration: 0,
        }
        this.detachAnimationOptions = {
          duration: 0,
        }
        this.hideAnimationOptions = {
          duration: 0,
        }
        this.showAnimationOptions = {
          duration: 0,
        }
        break;
    }

    // Passing the callbacks in the object breaks animateTo
    this.customTransitionCoordinator.registerNavParam(this.pageId,
      () => this.stackAnimation,
      (animationType) => this.attachAnimationStartCallback(animationType),
      (animationType) => this.attachAnimationEndCallback(animationType),
      this.attachAnimationOptions,
      (animationType) => this.detachAnimationStartCallback(animationType),
      (animationType) => this.detachAnimationEndCallback(animationType),
      this.detachAnimationOptions,
      (animationType) => this.showAnimationStartCallback(animationType),
      (animationType) => this.showAnimationEndCallback(animationType),
      this.showAnimationOptions,
      (animationType) => this.hideAnimationStartCallback(animationType),
      (animationType) => this.hideAnimationEndCallback(animationType),
      this.hideAnimationOptions,
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