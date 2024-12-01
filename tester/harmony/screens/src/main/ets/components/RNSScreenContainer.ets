import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenContainerDescriptor = Descriptor<"RNSScreenContainer", RNC.RNSScreenContainer.Props>

@Component
export struct RNSScreenContainer {
  public static readonly NAME = RNC.RNSScreenContainer.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenContainerDescriptor = {} as RNSScreenContainerDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenContainerDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenContainerDescriptor)
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
