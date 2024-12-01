import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenStackDescriptor = Descriptor<"RNSScreenStack", RNC.RNSScreenStack.Props>

@Component
export struct RNSScreenStack {
  public static readonly NAME = RNC.RNSScreenStack.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenStackDescriptor = {} as RNSScreenStackDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackDescriptor)
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
