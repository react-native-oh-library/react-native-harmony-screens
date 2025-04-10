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

import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { getAnimationConfig } from '../animations/AnimationHandler';
import { AnimateCallback, AnimationDefinition, CustomTransitionCoordinator } from '../animations/CustomTransition';
import { SafeAreaInsets } from '../utils/SafeAreaInsets';
import { RNSScreen } from './RNSScreen';

export type RNSScreenStackDescriptor = Descriptor<"RNSScreenStack", RNC.RNSScreenStack.Props>

@Component
export struct RNSScreenStack {
  public static readonly NAME = RNC.RNSScreenStack.NAME
  public static firstStackPerRNInstance: Map<number, number> = new Map();
  public ctx!: RNComponentContext
  public tag: number = 0
  private safeAreaInsets!: SafeAreaInsets;
  private cleanUpCallbacks: (() => void)[] = []
  private stackController: NavPathStack = new NavPathStack()
  private customTransitionCoordinator: CustomTransitionCoordinator = new CustomTransitionCoordinator()
  private eventEmitter: RNC.RNSScreenStack.EventEmitter | undefined = undefined
  @State private stack: number[] = []
  @State public topInset: number = 0;
  private statusBarHeight: number = 0;
  @State private isFirstNavigator: boolean | undefined = undefined;
  @Watch("onDescriptorChange") @State descriptor: RNSScreenStackDescriptor = {} as RNSScreenStackDescriptor
  @State replaceAnimation: string = "push";
  @State presentation: string = "push";
  static RECORD_PRESENTATION: string = "push";
  static ROOT_TAG: number = 0;
  static STATUS_BAR_HEIGHT: number = 0;

  updateStack(newChildren: number[]) {
    if (!newChildren || this.stack.length === 0) {
      for (let i = 0; i < newChildren.length; i++) {
        this.stackController.pushPathByName(newChildren[i].toString(), null)
      }
      return;
    }

    const differentElementIndex =
      newChildren.findIndex((value: number, index: number, obj: number[]) => {
        if (index < this.stack.length) {
          return this.stack[index] !== newChildren[index]
        } else {
          return index
        }
      })

    if (newChildren.length === this.stack.length && differentElementIndex === newChildren.length - 1) {
      this.stackController.replacePathByName(newChildren[differentElementIndex].toString(), null);
      return;
    }

    if (newChildren.length < this.stack.length) {
      this.stackController.popToIndex(differentElementIndex === -1 ? newChildren.length - 1 : differentElementIndex - 1)
    }

    if (differentElementIndex !== -1) {
      for (let i = differentElementIndex; i < newChildren.length; i++) {
        this.stackController.pushPathByName(newChildren[i].toString(), null)
      }
    }
  }

  onDescriptorChange() {
    const newChildren = this.descriptor.childrenTags;
    this.updateStack(newChildren)
    this.stack = [...newChildren]
  }

  async aboutToAppear() {
    if (RNSScreenStack.ROOT_TAG == 0) {
      RNSScreenStack.ROOT_TAG = this.tag;
    }
    this.eventEmitter = new RNC.RNSScreenStack.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackDescriptor)
      }
    ))
    this.safeAreaInsets = new SafeAreaInsets(this.ctx)
    if (true) {
      const insets = await this.safeAreaInsets.getSafeAreaInsets()
      this.statusBarHeight = insets.top;
      if (RNSScreenStack.STATUS_BAR_HEIGHT === 0 && insets.top > 0) {
        RNSScreenStack.STATUS_BAR_HEIGHT = insets.top;
      }
    }

    // FIXME: the approach of detecting if navigator should be moved down by the top safe area must be changed
    // we don't know if there isn't something above this navigator (although it shouldn't - but what about brownfield?)
    if (!RNSScreenStack.firstStackPerRNInstance.get(this.ctx.rnInstance.getId())) {
      RNSScreenStack.firstStackPerRNInstance.set(this.ctx.rnInstance.getId(), this.tag);
    }
    this.isFirstNavigator = RNSScreenStack.firstStackPerRNInstance.get(this.ctx.rnInstance.getId()) === this.tag;
    if (this.isFirstNavigator) {
      const insets = await this.safeAreaInsets.getSafeAreaInsets()
      this.topInset = insets.top
    }
    this.stackController.pushPathByName(this.stack[0].toString(), null)
  }

  private screenPropsChange(replaceAnimation: string, presentation: string) {
    this.replaceAnimation = replaceAnimation;
    this.presentation = presentation;
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  @Builder
  navDestinationBuilder(tag: string) {
    RNSScreen({
      ctx: this.ctx,
      tag: Number(tag),
      isFirstScreenInStack: this.stack.indexOf(Number(tag)) === 0,
      customTransitionCoordinator: this.customTransitionCoordinator,
      topInset: this.topInset,
      statusBarHeight: this.statusBarHeight,
      screenPropsChange: this.screenPropsChange.bind(this),
    })
  }

  shouldFallbackToDefaultAnimation(operation: NavigationOperation, from: NavContentInfo, to: NavContentInfo) {
    const defaultBehaviourAnimations = ['default', 'simple_push', 'flip']
    if (operation == NavigationOperation.PUSH && to.navDestinationId &&
    defaultBehaviourAnimations.includes(this.customTransitionCoordinator.getAnimateParam(to.navDestinationId)
      .getAnimationType())) {
      return true;
    }
    if (operation != NavigationOperation.PUSH && from.navDestinationId &&
    defaultBehaviourAnimations.includes(this.customTransitionCoordinator.getAnimateParam(from.navDestinationId)
      .getAnimationType())) {
      return true;
    }
    return false;
  }

  customNavContentTransitionHandler(from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) {
    // No custom animation for the home page
    if (from.index === -1 || to.index === -1) {
      return undefined;
    }

//    if (this.shouldFallbackToDefaultAnimation(operation, from, to)) {
//      return undefined;
//    }

    this.customTransitionCoordinator.operation = operation;
    return {
      timeout: 2000, // The limit duration of the transition animation
      transition: (transitionProxy: NavigationTransitionProxy) => {
        if (!from.navDestinationId || !to.navDestinationId) {
          return;
        }

        // Obtain the corresponding transition animation callback from the customTransitionCoordinator class based on the sequence of subpages.
        let fromParam: AnimateCallback = this.customTransitionCoordinator.getAnimateParam(from.navDestinationId);
        let toParam: AnimateCallback = this.customTransitionCoordinator.getAnimateParam(to.navDestinationId);
        let exitingScreenAnimation: AnimationDefinition;
        let enteringScreenAnimation: AnimationDefinition;
        let animationType: string

        if (operation == NavigationOperation.PUSH && this.replaceAnimation === 'pop') {
          exitingScreenAnimation = fromParam.detachAnimation;
          enteringScreenAnimation = toParam.showAnimation;
          animationType = fromParam.getAnimationType();
        } else if (operation == NavigationOperation.POP && this.replaceAnimation === 'push') {
          if ((RNSScreenStack.RECORD_PRESENTATION === 'transparentModal' || RNSScreenStack.RECORD_PRESENTATION === 'containedTransparentModal' || RNSScreenStack.RECORD_PRESENTATION === 'formSheet') && RNSScreenStack.RECORD_PRESENTATION !== this.presentation) {
            RNSScreenStack.RECORD_PRESENTATION = this.presentation
            exitingScreenAnimation = fromParam.detachAnimation;
            enteringScreenAnimation = toParam.showAnimation;
            animationType = fromParam.getAnimationType();
          } else {
            exitingScreenAnimation = fromParam.hideAnimation;
            enteringScreenAnimation = toParam.attachAnimation;
            animationType = toParam.getAnimationType();
          }
        } else if (operation == NavigationOperation.PUSH && this.replaceAnimation === 'push') {
          RNSScreenStack.RECORD_PRESENTATION = this.presentation;
          if (this.presentation === 'transparentModal' || this.presentation === 'containedTransparentModal' || this.presentation === 'formSheet') {
            exitingScreenAnimation = fromParam.hideAnimation;
            enteringScreenAnimation = toParam.attachAnimation;
            animationType = toParam.getAnimationType();
          } else {
            exitingScreenAnimation = fromParam.detachAnimation;
            enteringScreenAnimation = toParam.showAnimation;
            animationType = fromParam.getAnimationType();
          }
        } else if (operation == NavigationOperation.POP && this.replaceAnimation === 'pop') {
          exitingScreenAnimation = fromParam.hideAnimation;
          enteringScreenAnimation = toParam.attachAnimation;
          animationType = toParam.getAnimationType();
        } else if (operation == NavigationOperation.REPLACE && this.replaceAnimation === 'push'){
          exitingScreenAnimation = fromParam.detachAnimation;
          enteringScreenAnimation = toParam.showAnimation;
          animationType = fromParam.getAnimationType();
        } else if (operation == NavigationOperation.REPLACE && this.replaceAnimation === 'pop'){
          exitingScreenAnimation = fromParam.hideAnimation;
          enteringScreenAnimation = toParam.attachAnimation;
          animationType = fromParam.getAnimationType();
        } else {
          exitingScreenAnimation = fromParam.detachAnimation;
          enteringScreenAnimation = toParam.showAnimation;
          animationType = fromParam.getAnimationType();
        }

        const animationOptions = getAnimationConfig(animationType);

        enteringScreenAnimation.start(animationType);
        animateTo({
          duration: animationOptions.duration,
          curve: animationOptions.curve,
          tempo: animationOptions.tempo,
          onFinish: () => {
            transitionProxy.finishTransition();
            this.eventEmitter!.emit("finishTransitioning", {})
          }
        }, () => {
          enteringScreenAnimation.end(animationType);
        })

        exitingScreenAnimation.start(animationType);
        animateTo({
          duration: animationOptions.duration,
          curve: animationOptions.curve,
          tempo: animationOptions.tempo,
          onFinish: () => {
            transitionProxy.finishTransition();
          }
        }, () => {
          exitingScreenAnimation.end(animationType);
        })
      }
    } as NavigationAnimatedTransition;
  }

  build() {
    Stack() {
      if (!this.isFirstNavigator || this.topInset !== 0) {
        Navigation(this.stackController)
          .mode(NavigationMode.Stack)
          .navDestination(this.navDestinationBuilder)
          .titleMode(NavigationTitleMode.Mini)
          .hitTestBehavior(HitTestMode.Transparent)
          .hideNavBar(true)
          .customNavContentTransition((from: NavContentInfo, to: NavContentInfo,
            operation: NavigationOperation) => this.customNavContentTransitionHandler(from, to, operation))
      }
    }
  }
}
