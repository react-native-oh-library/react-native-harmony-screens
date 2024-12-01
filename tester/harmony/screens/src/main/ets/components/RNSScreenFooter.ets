import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenFooterDescriptor = Descriptor<"RNSScreenFooter", RNC.RNSScreenFooter.Props>

@Component
export struct RNSScreenFooter {
  public static readonly NAME = RNC.RNSScreenFooter.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenFooterDescriptor = {} as RNSScreenFooterDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenFooterDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenFooterDescriptor)
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
