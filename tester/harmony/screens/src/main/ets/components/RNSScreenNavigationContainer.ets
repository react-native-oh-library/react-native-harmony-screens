import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenNavigationContainerDescriptor = Descriptor<"RNSScreenNavigationContainer", RNC.RNSScreenNavigationContainer.Props>

@Component
export struct RNSScreenNavigationContainer {
  public static readonly NAME = RNC.RNSScreenNavigationContainer.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenNavigationContainerDescriptor = {} as RNSScreenNavigationContainerDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenNavigationContainerDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenNavigationContainerDescriptor)
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
