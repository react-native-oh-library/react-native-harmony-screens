import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSModalScreenDescriptor = Descriptor<"RNSModalScreen", RNC.RNSModalScreen.Props>

@Component
export struct RNSModalScreen {
  public static readonly NAME = RNC.RNSModalScreen.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSModalScreenDescriptor = {} as RNSModalScreenDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSModalScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSModalScreenDescriptor)
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
