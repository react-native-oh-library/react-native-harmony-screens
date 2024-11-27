import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSSearchBarProps extends ViewBaseProps {
  size: number
}

export type RNSSearchBarDescriptor = Descriptor<"RNSSearchBar", RNSSearchBarProps>

@Component
export struct RNSSearchBar {
  public static readonly NAME = RNC.RNSSearchBar.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSSearchBarDescriptor = {} as RNSSearchBarDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSSearchBarDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSSearchBarDescriptor)
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
