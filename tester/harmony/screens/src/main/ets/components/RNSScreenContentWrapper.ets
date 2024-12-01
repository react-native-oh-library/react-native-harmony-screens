import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenContentWrapperDescriptor = Descriptor<"RNSScreenContentWrapper", RNC.RNSScreenContentWrapper.Props>

@Component
export struct RNSScreenContentWrapper {
  public static readonly NAME = RNC.RNSScreenContentWrapper.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenContentWrapperDescriptor = {} as RNSScreenContentWrapperDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenContentWrapperDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenContentWrapperDescriptor)
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

