import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSScreenStackHeaderSubviewProps extends ViewBaseProps {
  size: number
}

export type RNSScreenStackHeaderSubviewDescriptor = Descriptor<"RNSScreenStackHeaderSubview", RNSScreenStackHeaderSubviewProps>

@Component
export struct RNSScreenStackHeaderSubview {
  public static readonly NAME = RNC.RNSScreenStackHeaderSubview.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenStackHeaderSubviewDescriptor = {} as RNSScreenStackHeaderSubviewDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackHeaderSubviewDescriptor)
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
