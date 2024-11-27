import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSModalScreenProps extends ViewBaseProps {
  size: number
}

export type RNSModalScreenDescriptor = Descriptor<"RNSModalScreen", RNSModalScreenProps>

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
    Stack() {
      ContentSlot(this.ctx.getContentForTag(this.tag))
    }
  }
}
