import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { SafeAreaInsets } from '../utils/SafeAreaInsets';
import { RNSScreen } from './RNSScreen';

export type RNSScreenStackDescriptor = Descriptor<"RNSScreenStack", RNC.RNSScreenStack.Props>

@Component
export struct RNSScreenStack {
  public static readonly NAME = RNC.RNSScreenStack.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @Watch("onDescriptorChange") @State descriptor: RNSScreenStackDescriptor = {} as RNSScreenStackDescriptor
  private cleanUpCallbacks: (() => void)[] = []
  private pageInfos: NavPathStack = new NavPathStack()
  @State private screens: number[] = []
  @State public topInset: number = 0;
  private safeAreaInsets!: SafeAreaInsets;

  onDescriptorChange() {
    const newChildren = this.descriptor.childrenTags;
    if (!newChildren) {
      return;
    }
    if (this.screens.length < newChildren.length && this.screens.length != 0) {
      this.pageInfos.pushPath({ name: String(newChildren[newChildren.length - 1]) })
    } else {
      if (this.screens.length - newChildren.length === 1) {
        this.pageInfos.pop();
      }
    }

    this.screens = [...newChildren]
  }

  @Builder
  PageMap(tag: string) {
    RNSScreen({
      ctx: this.ctx,
      pageInfos: this.pageInfos,
      screens: this.screens,
      topInset: this.topInset,
      tag: Number(tag)
    })
  }

  async aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackDescriptor)
      }
    ))
    this.safeAreaInsets = new SafeAreaInsets(this.ctx)
    const insets = await this.safeAreaInsets.getSafeAreaInsets()
    this.topInset = insets.top
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  build() {
    Stack() {
      if (this.topInset !== 0) {
        RNSScreen({
          ctx: this.ctx,
          pageInfos: this.pageInfos,
          screens: this.screens,
          topInset: this.topInset,
          tag: Number(this.screens[0])
        })
        Navigation(this.pageInfos)
          .mode(NavigationMode.Stack)
          .navDestination(this.PageMap)
          .hideToolBar(true)
          .titleMode(NavigationTitleMode.Full)
      }
    }.margin({
      top: this.topInset
    })
  }
}
