import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
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
  @State private stack: number[] = []
  @State public topInset: number = 0;
  @State private isFirstNavigator: boolean | undefined = undefined;
  @Watch("onDescriptorChange") @State descriptor: RNSScreenStackDescriptor = {} as RNSScreenStackDescriptor

  updateStack(newChildren: number[]) {
    if (!newChildren || this.stack.length === 0) {
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
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackDescriptor)
      }
    ))
    this.safeAreaInsets = new SafeAreaInsets(this.ctx)
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

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  @Builder
  navDestinationBuilder(tag: string) {
    RNSScreen({
      ctx: this.ctx,
      tag: Number(tag),
      isFirstScreenInStack: false,
      customTransitionCoordinator: this.customTransitionCoordinator,
      topInset: this.topInset,
    })
  }

  customNavContentTransitionHandler(from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) {
    // No custom animation for the home page
    if (from.index === -1 || to.index === -1) {
      return undefined;
    }

    // Fallback to default animation
    if (operation == NavigationOperation.PUSH && to.navDestinationId &&
    ['default', 'simple_push', 'flip'].includes(this.customTransitionCoordinator.getAnimateParam(to.navDestinationId)
      .getAnimationType())) {
      return undefined;
    } else if (operation != NavigationOperation.PUSH && from.navDestinationId &&
    ['default', 'simple_push', 'flip'].includes(this.customTransitionCoordinator.getAnimateParam(from.navDestinationId)
      .getAnimationType())) {
      return undefined;
    }

    this.customTransitionCoordinator.operation = operation;
    return {
      timeout: 7000, // the limit duration of the transition animation
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

        if (operation == NavigationOperation.PUSH) {
          exitingScreenAnimation = fromParam.hideAnimation;
          enteringScreenAnimation = toParam.attachAnimation;
          animationType = toParam.getAnimationType();
        } else {
          exitingScreenAnimation = fromParam.detachAnimation;
          enteringScreenAnimation = toParam.showAnimation;
          animationType = fromParam.getAnimationType();
        }

        enteringScreenAnimation.start(animationType);
        animateTo({
          duration: enteringScreenAnimation.options.duration,
          curve: enteringScreenAnimation.options.curve,
          tempo: enteringScreenAnimation.options.tempo,
          onFinish: () => {
            transitionProxy.finishTransition();
          }
        }, () => {
          enteringScreenAnimation.end(animationType);
        })

        exitingScreenAnimation.start(animationType);
        animateTo({
          duration: exitingScreenAnimation.options.duration,
          curve: exitingScreenAnimation.options.curve,
          tempo: exitingScreenAnimation.options.tempo,
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
          .titleMode(NavigationTitleMode.Full)
          .hitTestBehavior(HitTestMode.Transparent)
          .hideNavBar(true)
          .customNavContentTransition((from: NavContentInfo, to: NavContentInfo,
            operation: NavigationOperation) => this.customNavContentTransitionHandler(from, to, operation))
      }
    }.margin({
      top: this.topInset
    })
  }
}
