/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import {
  ColorValue,
  convertColorValueToHex,
  Descriptor,
  RNComponentContext,
  RNViewBase,
} from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { CustomTransitionCoordinator } from '../animations/CustomTransition';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { window } from '@kit.ArkUI';
import { AnimationHandlerEvent, getNewAnimationState } from '../animations/AnimationHandler';
import { RNSScreenTitleHeader } from "./RNSScreenTitleHeader"
import { TITLEBAR_HEIGHT } from '../Constants';
import common from '@ohos.app.ability.common';
import i18n from '@ohos.i18n';
import { RNSScreenStack } from './RNSScreenStack'

export type RNSScreenDescriptor = Descriptor<"RNSScreen", RNC.RNSScreen.Props>

interface StatusBarConfiguration {
  statusBarStyle: string;
  statusBarAnimation: boolean;
  statusBarHidden: boolean;
  statusBarColor: string
}

interface NavigationBarConfiguration {
  navigationBarColor: string| undefined;
  navigationBarTranslucent: boolean| undefined;
  navigationBarHidden: boolean| undefined;
  nativeBackButtonDismissalEnabled: boolean| undefined;
}

interface GestureResponseDistance {
  start: number | undefined;
  end: number | undefined;
  bottom: number | undefined;
  top: number | undefined;
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
  @State stackPresentationMode: string = '';
  private cleanupCommandCallback?: () => void = undefined;
  static ROOT_TAG: number = 0;

  @State public topInset: number = 0;
  private topInsetTmp: number = 0;
  public screenPropsChange: (replaceAnimation: string, presentation: string) => void = (r: string, p: string)=>{};
  private gestureEnabled: boolean = false;
  private fullScreenSwipeEnabled: boolean = false;
  private customAnimationOnSwipe: boolean = false;
  private swipeDirection: string| undefined = undefined;
  private top: number = -1;
  private end: number = -1;
  private start: number = -1;
  private bottom: number = -1;
  private couldSwipe: boolean = false;
  private isInverted: boolean = false;
  private translation: number = 0;
  private velocity: number = 0;
  private distance: number = 0;
  private static TOP_PAGEID: string = 'default'
  private static RECORD_TOP_PAGEID: string = 'default'

  @State isStatusBarShow: boolean = false;
  private statusBarHeight: number = 0;
  private preventNativeDismiss: boolean = false;
  private directions: string= ''
  @State titleBarTranslucent: boolean = false;
  @State topInsetEnabled: boolean = true;
  @State titleBarBgColor: string = '#00000000';

  @State descriptor: RNSScreenDescriptor = {} as RNSScreenDescriptor
  @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor | undefined = undefined
  @State titleHeight: number = 0;
  @State presentationMode: NavDestinationMode = NavDestinationMode.STANDARD;
  @State stackAnimation: string = "default";
  @State replaceAnimation: string = "push";
  @State shouldHideTitleBar: boolean = false;
  @State titleBarBackgroundColor: string | undefined = undefined;
  @State backgroundColorValue: string | undefined = undefined
  @State translateXValue: string = '0';
  @State translateYValue: string = '0';
  @State opacityValue: number = 1;
  @State screenOrientation: string = 'default';

  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State positionX: number = 0;
  @State positionY: number = 0;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right });
  private stackController: NavPathStack | null = null;

  private statusBarConfiguration: StatusBarConfiguration = {
    statusBarStyle: "",
    statusBarAnimation: false,
    statusBarHidden: false,
    statusBarColor: ''
  }
  private navigationBarConfiguration: NavigationBarConfiguration = {
    navigationBarColor: '',
    navigationBarTranslucent: false,
    navigationBarHidden: false,
    nativeBackButtonDismissalEnabled: false
  }

  private gestureResponseDistance: GestureResponseDistance = {
    start: undefined,
    end: undefined,
    bottom: undefined,
    top: undefined
  }
  async aboutToAppear() {
    if (RNSScreen.ROOT_TAG === 0) {
      RNSScreen.ROOT_TAG = this.tag;
    }
    this.eventEmitter = new RNC.RNSScreen.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      async (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenDescriptor)
        await this.updateState();
        this.setScreenOrientation();
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
    await this.updateState()
    this.setScreenOrientation();
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  onScreenPropsChange(presentation: string) {
    this.screenPropsChange(this.replaceAnimation, presentation)
  }

  async updateState(forceUpdate: boolean = false) {
    this.preventNativeDismiss = this.descriptor.rawProps["preventNativeDismiss"];
    this.gestureEnabled = this.descriptor.rawProps["gestureEnabled"];
    this.fullScreenSwipeEnabled = this.descriptor.rawProps["fullScreenSwipeEnabled"];
    this.customAnimationOnSwipe = this.descriptor.rawProps["customAnimationOnSwipe"];
    this.swipeDirection = this.descriptor.rawProps["SwipeDirection"];
    let gestureResponseDistanceTmp: GestureResponseDistance = this.descriptor.rawProps["gestureResponseDistance"];
    if (gestureResponseDistanceTmp) {
      this.top = gestureResponseDistanceTmp.top?gestureResponseDistanceTmp.top:-1;
      this.end = gestureResponseDistanceTmp.end?gestureResponseDistanceTmp.end:-1;
      this.start = gestureResponseDistanceTmp.start?gestureResponseDistanceTmp.start:-1;
      this.bottom = gestureResponseDistanceTmp.bottom?gestureResponseDistanceTmp.bottom:-1;

      this.gestureResponseDistance.start = this.start;
      this.gestureResponseDistance.end = this.end;
      this.gestureResponseDistance.top = this.top;
      this.gestureResponseDistance.bottom = this.bottom;
    }
    if (this.stackAnimation !== this.descriptor.rawProps["stackAnimation"] || "default") {
      this.stackAnimation = this.descriptor.rawProps["stackAnimation"] || "default"
    }
    if (this.replaceAnimation !== this.descriptor.rawProps["replaceAnimation"] || "push") {
      this.replaceAnimation = this.descriptor.rawProps["replaceAnimation"] || "push"
    }

    const presentation: string = this.descriptor.rawProps["stackPresentation"];
    this.onScreenPropsChange(presentation)
    if (["modal", "transparentModal", "containedModal", "containedTransparentModal",
      "fullScreenModal", "formSheet"].includes(presentation)) {
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

    let statusBarColorTmp: ESObject = this.descriptor.rawProps["statusBarColor"];
    let statusBarColor: string = '';
    if (typeof statusBarColorTmp == 'number') {
      statusBarColor = convertColorValueToHex(statusBarColorTmp);
    } else {
      statusBarColor = statusBarColorTmp;
    }
    let statusBarHiddenTmp: boolean = this.descriptor.rawProps["statusBarHidden"];
    if(!!!statusBarHiddenTmp) {
      statusBarHiddenTmp = false;
    }
    const newStatusBarConfiguration: StatusBarConfiguration = {
      statusBarStyle: this.descriptor.rawProps["statusBarStyle"],
      statusBarAnimation: this.descriptor.rawProps["statusBarAnimation"] !== "none",
      statusBarHidden: statusBarHiddenTmp,
      statusBarColor: statusBarColor
    }
    let statusBarContentColor = "#000000"
    if (newStatusBarConfiguration.statusBarStyle === "light" || newStatusBarConfiguration.statusBarStyle === "inverted") {
      statusBarContentColor = "#E5FFFFFF"
    }
    let statusBarTranslucentTmp: boolean = this.descriptor.rawProps["statusBarTranslucent"];
    if (statusBarTranslucentTmp) {
      newStatusBarConfiguration.statusBarColor = "#00000000"
    } else {
      newStatusBarConfiguration.statusBarColor = statusBarColor;
    }
    this.stackPresentationMode = presentation;

    if (JSON.stringify(this.statusBarConfiguration) !== JSON.stringify(newStatusBarConfiguration) || this.stackPresentationMode !== presentation || this.stackPresentationMode !== 'fullScreenModal') {
      this.statusBarConfiguration = newStatusBarConfiguration
      const windowInstance = await window.getLastWindow(this.ctx.uiAbilityContext);

      if(this.pageId !== "default") {
        {
          await windowInstance.setSpecificSystemBarEnabled('status', !this.statusBarConfiguration.statusBarHidden);
          if (!this.statusBarConfiguration.statusBarHidden) {
            this.isStatusBarShow = true;
          } else {
            this.isStatusBarShow = false;
          }
        }
      }

      windowInstance.setWindowSystemBarProperties({
        statusBarContentColor: statusBarContentColor,
        // statusBarColor: this.statusBarConfiguration.statusBarColor,
        enableStatusBarAnimation: this.statusBarConfiguration.statusBarAnimation,
      });
    }
    let navigationBarColor: string = this.descriptor.rawProps["navigationBarColor"];
    let navigationBarTranslucent: boolean = this.descriptor.rawProps["navigationBarTranslucent"];
    let navigationBarHidden: boolean = this.descriptor.rawProps["navigationBarHidden"];
    let nativeBackButtonDismissalEnabled: boolean = this.descriptor.rawProps["nativeBackButtonDismissalEnabled"];
    const TmpNavigationBarConfiguration: NavigationBarConfiguration = {
      navigationBarColor: navigationBarColor,
      navigationBarTranslucent: navigationBarTranslucent,
      navigationBarHidden: navigationBarHidden,
      nativeBackButtonDismissalEnabled: nativeBackButtonDismissalEnabled
    }

    if (JSON.stringify(this.navigationBarConfiguration) !== JSON.stringify(TmpNavigationBarConfiguration)) {
      this.navigationBarConfiguration = TmpNavigationBarConfiguration;
      const windowInstance = await window.getLastWindow(this.ctx.uiAbilityContext);

      await windowInstance.setSpecificSystemBarEnabled('navigation', !this.navigationBarConfiguration.navigationBarHidden);
      windowInstance.setWindowSystemBarProperties({
        navigationBarColor: this.navigationBarConfiguration.navigationBarColor
      });
    }
    this.updateNativeHeaderHeight();
  }

  async updateHeaderConfigState() {
    if (!this.screenStackHeaderConfigDescriptor) {
      return
    }

    if (this.shouldHideTitleBar !== (this.screenStackHeaderConfigDescriptor.rawProps["hidden"])) {
      this.shouldHideTitleBar = this.screenStackHeaderConfigDescriptor.rawProps["hidden"]
    }

    if (this.titleBarBackgroundColor !== this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"]) {
      this.titleBarBackgroundColor = this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"]
      let tmp: ColorValue = this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"];
      if(tmp  && tmp.toString().startsWith('rgb')) {
        let r = convertColorValueToHex(tmp);
        this.titleBarBackgroundColor = r;
      }
    }

    this.titleBarTranslucent = this.screenStackHeaderConfigDescriptor.rawProps["translucent"];
    if (this.titleBarBackgroundColor || this.titleBarTranslucent) {
      this.titleBarBgColor = this.titleBarTranslucent?"#00000000":(this.titleBarBackgroundColor?this.titleBarBackgroundColor:"#00000000");
    }

    this.updateNativeHeaderHeight();
  }

  updateNativeHeaderHeight() {
    if (!this.screenStackHeaderConfigDescriptor) {
      return
    }

    this.topInsetEnabled = this.screenStackHeaderConfigDescriptor.rawProps["topInsetEnabled"];
    this.directions = this.screenStackHeaderConfigDescriptor.rawProps["direction"];
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

    if (this.pageId === 'default') {
      return;
    }

    if(this.titleBarBackgroundColor === 'transparent'){
      this.eventEmitter?.emit("headerHeightChange", {
        headerHeight: 0
      })
    } else {
      this.eventEmitter?.emit("headerHeightChange", {
        headerHeight:(!this.shouldHideTitleBar?(this.isStatusBarShow?(this.stackPresentationMode===''?0:(this.topInsetEnabled?this.statusBarHeight:0)):0):0)+this.titleHeight
      })
    }

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
  private setScreenOrientation() {
    if (!this.descriptor) {
      return;
    }
    let orientation: string = this.descriptor.rawProps["screenOrientation"];
    let orientationTmp = -1; // window.Orientation.UNSPECIFIED;
    if (this.pageId !== "default" && this.pageId === RNSScreen.TOP_PAGEID) {
      this.screenOrientation = orientation;

      if (this.screenOrientation == "all") {
        orientationTmp = window.Orientation.AUTO_ROTATION;
      } else if (this.screenOrientation == "portrait") {
        orientationTmp = window.Orientation.PORTRAIT;
      } else if (this.screenOrientation == "portrait_up") {
        orientationTmp = window.Orientation.PORTRAIT;
      } else if (this.screenOrientation == "portrait_down") {
        orientationTmp = window.Orientation.PORTRAIT_INVERTED;
      } else if (this.screenOrientation == "landscape") {
        orientationTmp = window.Orientation.LANDSCAPE;
      } else if (this.screenOrientation == "landscape_left") {
        orientationTmp = window.Orientation.LANDSCAPE_INVERTED;
      } else if (this.screenOrientation == "landscape_right") {
        orientationTmp = window.Orientation.LANDSCAPE;
      } else {
        orientationTmp = window.Orientation.UNSPECIFIED;
      }

      let context = getContext(this) as common.UIAbilityContext;
      window.getLastWindow(context).then((lastWindow) => {
        lastWindow.setPreferredOrientation(orientationTmp);
      });
    }
  }
  
  private isRtl() {
    let flag: boolean = false;
    if (this.directions) {
      if (this.directions === 'rtl') {
        flag = true;
      } else if (this.directions === 'ltr') {
        flag = false;
      }
    }
    return flag;
  }
  
  private isInGestureResponseDistance(event: GestureEvent): boolean {
    let x = event.fingerList[0].globalX;
    let y = event.fingerList[0].globalY;
    let isRTL = this.isRtl();
    if (isRTL) {
      let vWidth: number = event.target.area.width as number;
      x = vWidth - x;
    }
    return !((this.start != -1 && x < this.start) || (this.end != -1 && x > this.end) || (this.top != -1 && y < this.top) || (this.bottom != -1 && y > this.bottom));
  }

  private isCustomAnimation(): boolean {
    return (this.stackAnimation != "flip" && this.stackAnimation != "default");
  }

  private gestureRecognizerShouldBegin(event: GestureEvent): boolean {
    if (!this.gestureEnabled || !this.fullScreenSwipeEnabled) {
      return false;
    }

    let inDistance: boolean = this.isInGestureResponseDistance(event);
    if (!inDistance) {
      return false;
    }

    let flag = false;
    // if (this.customAnimationOnSwipe && this.isCustomAnimation()) {
    {
      let isRTL = this.isRtl();
      let isSlideFromLeft: boolean = this.stackAnimation === "slide_from_left";
      let isCorrectEdge: boolean = (isRTL && event.offsetX < 0 ) || (!isRTL && isSlideFromLeft && event.offsetX < 0) || (isRTL && isSlideFromLeft && event.offsetX > 0) || (!isRTL && event.offsetX > 0)
      if (isCorrectEdge) {
        flag = true
        return flag;
      }
    }

    return flag;
  }

  private handleSwipe(event: GestureEvent): void {

    if (this.swipeDirection && this.swipeDirection === "vertical") {
      this.translation = event.offsetY;
      this.velocity = event.offsetY;
      this.distance= event.target.area.height as number;

      this.offsetY = this.positionY + event.offsetY;
      this.translateYValue = this.offsetY.toString();
    } else {
      this.translation = event.offsetX;
      this.velocity = event.offsetX;
      this.distance= event.target.area.width as number;
      let isRTL = this.isRtl();
      if (isRTL) {
        this.translation = -this.translation;
        this.velocity = -this.velocity;
        this.offsetX = this.positionX + event.offsetX;
      } else  {
        this.offsetX = this.positionX + event.offsetX;
      }
      this.translateXValue = this.offsetX.toString();
    }

    let isInverted: boolean = this.stackAnimation === "slide_from_left";
    let transitionProgress: number = (this.translation / this.distance);
    transitionProgress = isInverted ? transitionProgress * -1 : transitionProgress;
    this.eventEmitter!.emit("transitionProgress", {progress: transitionProgress, closing: true ? 1 : 0, goingForward: false ? 1 : 0})
    this.customTransitionCoordinator.updateProgress(transitionProgress);
  }

  private backBtnPressed() {
    this.backPressed();
  }

  @Builder
  screenTitleBuilder() {
    RNSScreenTitleHeader({
      ctx: this.ctx,
      screenStackHeaderConfigTag: this.screenStackHeaderConfigTag,
      isFirstScreenInStack: this.isFirstScreenInStack,
      backBtnPressed: this.backBtnPressed.bind(this),
    }).position({ x:0, y: (!this.shouldHideTitleBar?(this.isStatusBarShow?(this.stackPresentationMode===''?0:(this.topInsetEnabled?this.statusBarHeight:0)):0):0) })
  }

  private isComponentOfType(childTag: number, componentType: string): boolean {
    const descriptor = this.ctx.descriptorRegistry.getDescriptor<Descriptor>(childTag)
    if (!descriptor) {
      return false;
    }
    return descriptor.type === componentType;
  }

  private backPressed(){
    let pathArray = this.stackController?.getAllPathName();
    if (pathArray?.length && pathArray?.length > 1) {
      if (this.preventNativeDismiss) {
        this.eventEmitter!.emit("nativeDismissCancelled", {
          dismissCount: this.dismissCount
        })
      } else {
        this.eventEmitter!.emit("dismissed", {
          dismissCount: this.dismissCount
        })
      }
    }
  }
  
  build() {
    NavDestination() {
      RNViewBase({ ctx: this.ctx, tag: this.tag }) {
        Stack() {
          if(this.isStatusBarShow) {
            Text('').height(this.statusBarHeight).width('100%').backgroundColor(this.titleBarBgColor).position({x:0, y:0})
          }

          Stack(){
            ContentSlot(this.ctx.getContentForTag(this.tag))
          }

          if (this.stackPresentationMode !== '' && !this.shouldHideTitleBar) {
            this.screenTitleBuilder()
          }
        }
      }

    }
    .hideTitleBar(true)
    .mode(this.presentationMode)
    .onReady((context: NavDestinationContext) => {
      if (context.navDestinationId) {
        this.pageId = context.navDestinationId;
        this.registerAnimation();
        this.stackController = context.pathStack;
      }
    })
    .onWillAppear(() => {
      this.eventEmitter!.emit("willAppear", {})
    })
    .onAppear(() => {
      this.eventEmitter!.emit("appear", {})
    })
    .onShown(() => {
      RNSScreen.TOP_PAGEID = this.pageId;
      this.updateState(true)
      this.updateHeaderConfigState()
      this.setScreenOrientation()
    })
    .onWillDisappear(() => {
      this.eventEmitter!.emit("willDisappear", {})
    })
    .onDisAppear(() => {
      this.customTransitionCoordinator.unregisterNavParam(this.pageId);
      this.eventEmitter!.emit("disappear", {})
    })
    .onBackPressed(() => {
      this.backPressed();
      return false;
    })
    .backgroundColor(this.backgroundColorValue)
    .translate({ x: this.translateXValue, y: this.translateYValue })
    .opacity(this.opacityValue)
    .gesture(
      PanGesture(this.panOption)
        .onActionStart((event: GestureEvent) => {
          this.couldSwipe = this.gestureRecognizerShouldBegin(event)
          if (this.couldSwipe) {
            this.isInverted = this.stackAnimation === "slide_from_left";
          }
        })
        .onActionUpdate((event: GestureEvent) => {
          if (this.couldSwipe) {
            this.handleSwipe(event);
          }
        })
        .onActionCancel(() => {
          this.couldSwipe = false;
          this.eventEmitter!.emit("gestureCancel", {})
          this.customTransitionCoordinator.cancelTransition();
        })
        .onActionEnd((event: GestureEvent) => {
          if (this.couldSwipe) {
            this.positionX = this.offsetX
            this.positionY = this.offsetY

            let snapPoint: number = this.distance / 2;
            let gestureDistance: number = this.translation + this.velocity * 0.3;
            gestureDistance = this.isInverted ? gestureDistance * -1 : gestureDistance;
            let shouldFinishTransition: boolean = gestureDistance > snapPoint;
            if (shouldFinishTransition) {
              this.eventEmitter!.emit("dismissed", {
                dismissCount: this.dismissCount
              })
              this.customTransitionCoordinator.finishTransition();
            } else {
              this.translateXValue = '0';
              this.translateYValue = '0';
              this.customTransitionCoordinator.cancelTransition();
              this.eventEmitter!.emit("gestureCancel", {})
            }
          }
          this.offsetY = 0;
          this.offsetX = 0;
          this.positionX = 0;
          this.positionY = 0;

          this.couldSwipe = false;
        })
    )
  }
}