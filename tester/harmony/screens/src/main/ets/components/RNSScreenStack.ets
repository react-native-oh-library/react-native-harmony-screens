import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
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
      this.stackController.popToIndex(differentElementIndex === -1 ? newChildren.length - 2 : differentElementIndex - 2)
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
      topInset: this.topInset,
    })
  }

  build() {
    Stack() {
      if (!this.isFirstNavigator || this.topInset !== 0) {
        RNSScreen({
          ctx: this.ctx,
          tag: Number(this.stack[0]),
          topInset: this.topInset,
          isFirstScreenInStack: true,
        })
      }
      Navigation(this.stackController)
        .mode(NavigationMode.Stack)
        .navDestination(this.navDestinationBuilder)
        .hideToolBar(true)
        .titleMode(NavigationTitleMode.Full)
    }.margin({
      top: this.topInset
    })
  }
}
