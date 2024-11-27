import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSScreenContentWrapperProps extends ViewBaseProps {
  size: number
}

export type RNSScreenContentWrapperDescriptor = Descriptor<"RNSScreenContentWrapper", RNSScreenContentWrapperProps>

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
    Stack() {
      ContentSlot(this.ctx.getContentForTag(this.tag))
    }
  }
}
