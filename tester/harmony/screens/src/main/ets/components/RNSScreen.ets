import { Descriptor, RNComponentContext, RNViewBase, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenDescriptor = Descriptor<"RNSScreen", RNC.RNSScreen.Props>

const TITLEBAR_HEIGHT = 56;

@Component
export struct RNSScreen {
  public static readonly NAME = RNC.RNSScreen.NAME
  public ctx!: RNComponentContext
  public pageInfos!: NavPathStack
  public screens!: number[]
  public tag: number = 0
  @State descriptor: RNSScreenDescriptor = {} as RNSScreenDescriptor
  private eventEmitter: RNC.RNSScreen.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  private index = 0;
  @State public topInset: number = 0;
  public dismissCount: number = 0;

  async aboutToAppear() {
    this.eventEmitter = new RNC.RNSScreen.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenDescriptor)
      }
    ))
    this.index = this.screens.indexOf(this.tag);
    this.eventEmitter?.emit("headerHeightChange", {
      headerHeight: this.topInset + (this.index > 0 ? TITLEBAR_HEIGHT : 0)
    })
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())

    // TODO: Component unmounted, initialize goBack animation if needed
    this.pageInfos?.pop();
  }

  build() {
    NavDestination() {
      RNViewBase({ ctx: this.ctx, tag: this.tag }) {
        Stack() {
          ContentSlot(this.ctx.getContentForTag(this.tag))
        }.offset({
          top: -this.topInset - (this.index > 0 ? TITLEBAR_HEIGHT : 0)
        })
      }
    }
    .onWillAppear(() => this.eventEmitter!.emit("willAppear", {}))
    .onAppear(() => this.eventEmitter!.emit("appear", {}))
    .onWillDisappear(() => {
      this.eventEmitter!.emit("willDisappear", {})
    })
    .onDisAppear(() => {
      this.eventEmitter!.emit("disappear", {})
    })
    .onDetach(() => {
      this.eventEmitter!.emit("dismissed", {
        dismissCount: this.dismissCount
      })
    })
  }
}