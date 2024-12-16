import { Descriptor, RNComponentContext, RNViewBase, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { CustomTransitionCoordinator } from '../animations/CustomTransition';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { window } from '@kit.ArkUI';
import { AnimationHandlerEvent, getNewAnimationState } from '../animations/AnimationHandler';
import { RNSScreenTitleHeader } from "./RNSScreenTitleHeader"
import { TITLEBAR_HEIGHT } from '../Constants';

export type RNSScreenDescriptor = Descriptor<"RNSScreen", RNC.RNSScreen.Props>

interface StatusBarConfiguration {
  statusBarStyle: string;
  statusBarAnimation: boolean;
  statusBarHidden: boolean;
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
  private pageId: string = 'default';
  private screenStackHeaderConfigTag!: number | undefined
  @State public topInset: number = 0;
  @State descriptor: RNSScreenDescriptor = {} as RNSScreenDescriptor
  @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor =
    {} as RNSScreenStackHeaderConfigDescriptor
  @State titleHeight: number = 0;
  @State presentationMode: NavDestinationMode = NavDestinationMode.STANDARD;
  @State stackAnimation: string = "default";
  @State shouldHideTitleBar: boolean = false;
  @State titleBarBackgroundColor: string | undefined = undefined;
  @State backgroundColorValue: string | undefined = undefined
  @State translateXValue: string = '0';
  @State translateYValue: string = '0';
  @State opacityValue: number = 1;
  private statusBarConfiguration: StatusBarConfiguration = {
    statusBarStyle: "",
    statusBarAnimation: false,
    statusBarHidden: false,
  }

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSScreen.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenDescriptor)
        this.updateState()
      }
    ))

    this.screenStackHeaderConfigTag =
      this.descriptor.childrenTags.find((childTag) => this.isComponentOfType(childTag,
        "RNSScreenStackHeaderConfig"))

    if (this.screenStackHeaderConfigTag) {
      this.screenStackHeaderConfigDescriptor =
        this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderConfigDescriptor>(this.screenStackHeaderConfigTag)
      this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.screenStackHeaderConfigTag,
        (newDescriptor) => {
          this.screenStackHeaderConfigDescriptor = (newDescriptor as RNSScreenStackHeaderConfigDescriptor)
          this.updateHeaderConfigState()
        }
      ))
      this.updateHeaderConfigState()
    }

    this.updateState()
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  async updateState() {
    this.updateNativeHeaderHeight()

    if (this.stackAnimation !== this.descriptor.rawProps["stackAnimation"] || "default") {
      this.stackAnimation = this.descriptor.rawProps["stackAnimation"] || "default"
    }

    const presentation: string = this.descriptor.rawProps["stackPresentation"] || "";
    if (["modal", "transparentModal", "containedModal", "containedTransparentModal",
      "fullScreenModal"].includes(presentation)) {
      if (this.presentationMode !== NavDestinationMode.DIALOG) {
        this.presentationMode = NavDestinationMode.DIALOG
      }
      if (this.stackAnimation !== 'fade') {
        this.stackAnimation = 'fade'
      }
    }

    if (presentation.includes("transparent") && this.backgroundColorValue !== 'rgba(0,0,0,0)') {
      this.backgroundColorValue = 'rgba(0,0,0,0)'
    }

    const newStatusBarConfiguration: StatusBarConfiguration = {
      statusBarStyle: this.descriptor.rawProps["statusBarStyle"],
      statusBarAnimation: this.descriptor.rawProps["statusBarAnimation"] !== "none",
      statusBarHidden: this.descriptor.rawProps["statusBarHidden"],
    }

    if (JSON.stringify(newStatusBarConfiguration) !== JSON.stringify(this.statusBarConfiguration)) {
      this.statusBarConfiguration = newStatusBarConfiguration
      let statusBarContentColor = "#000000"
      if (this.statusBarConfiguration.statusBarStyle === "light") {
        statusBarContentColor = "#E5FFFFFF"
      }
      const windowInstance = await window.getLastWindow(this.ctx.uiAbilityContext);
      await windowInstance.setSpecificSystemBarEnabled('status', !this.statusBarConfiguration.statusBarHidden);
      windowInstance.setWindowSystemBarProperties({
        statusBarContentColor: statusBarContentColor,
        enableStatusBarAnimation: this.statusBarConfiguration.statusBarAnimation,
      });
    }
  }

  updateHeaderConfigState() {
    this.updateNativeHeaderHeight()

    if (this.shouldHideTitleBar !== (this.screenStackHeaderConfigDescriptor.rawProps["hidden"] ||
      this.presentationMode === NavDestinationMode.DIALOG)) {
      this.shouldHideTitleBar = this.screenStackHeaderConfigDescriptor.rawProps["hidden"] ||
        this.presentationMode === NavDestinationMode.DIALOG
    }

    if (this.titleBarBackgroundColor !== this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"]) {
      this.titleBarBackgroundColor = this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"]
    }
  }

  updateNativeHeaderHeight() {
    let newTitleHeight: number = this.titleHeight;
    if (this.screenStackHeaderConfigDescriptor.rawProps["hidden"] ||
      this.presentationMode === NavDestinationMode.DIALOG) {
      newTitleHeight = 0;
    } else if (this.screenStackHeaderConfigDescriptor.rawProps["title"] || !this.isFirstScreenInStack) {
      newTitleHeight = TITLEBAR_HEIGHT
    }

    if (this.titleHeight !== newTitleHeight) {
      this.titleHeight = newTitleHeight;
    }

    this.eventEmitter?.emit("headerHeightChange", {
      headerHeight: this.topInset + this.titleHeight
    })
  }

  handleAnimation(animationType: string, animationEvent: AnimationHandlerEvent): void {
    const newState = getNewAnimationState(animationType, animationEvent)
    if (newState.translateXValue !== undefined) {
      this.translateXValue = newState.translateXValue;
    }
    if (newState.translateYValue !== undefined) {
      this.translateYValue = newState.translateYValue
    }
    if (newState.opacityValue !== undefined) {
      this.opacityValue = newState.opacityValue
    }
  }

  registerAnimation() {
    // Passing the callbacks wrapped in the object breaks animateTo
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

  @Builder
  screenTitleBuilder() {
    RNSScreenTitleHeader({
      ctx: this.ctx,
      screenStackHeaderConfigTag: this.screenStackHeaderConfigTag,
      isFirstScreenInStack: this.isFirstScreenInStack
    })
  }

  private isComponentOfType(childTag: number, componentType: string): boolean {
    const descriptor = this.ctx.descriptorRegistry.getDescriptor<Descriptor>(childTag)
    return descriptor.type === componentType;
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
      backgroundColor: this.titleBarBackgroundColor,
    })
    .mode(this.presentationMode)
    .onReady((context: NavDestinationContext) => {
      if (context.navDestinationId) {
        this.pageId = context.navDestinationId;
        this.registerAnimation();
      }
    })
    .hideTitleBar(this.shouldHideTitleBar)
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
    .backgroundColor(this.backgroundColorValue)
    .translate({ x: this.translateXValue, y: this.translateYValue })
    .opacity(this.opacityValue)
  }
}