import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSFullWindowOverlayDescriptor = Descriptor<"RNSFullWindowOverlay", RNC.RNSFullWindowOverlay.Props>

@Component
export struct RNSFullWindowOverlay {
  public static readonly NAME = RNC.RNSFullWindowOverlay.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSFullWindowOverlayDescriptor = {} as RNSFullWindowOverlayDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSFullWindowOverlayDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSFullWindowOverlayDescriptor)
      }
    ))
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  build() {
    ContentSlot(this.ctx.getContentForTag(this.tag))
  }
}
