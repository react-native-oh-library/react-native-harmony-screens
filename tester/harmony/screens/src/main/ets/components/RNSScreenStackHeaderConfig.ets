import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSScreenStackHeaderConfigProps extends ViewBaseProps {
  size: number
}

export type RNSScreenStackHeaderConfigDescriptor = Descriptor<"RNSScreenStackHeaderConfig", RNSScreenStackHeaderConfigProps>

@Component
export struct RNSScreenStackHeaderConfig {
  public static readonly NAME = RNC.RNSScreenStackHeaderConfig.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenStackHeaderConfigDescriptor = {} as RNSScreenStackHeaderConfigDescriptor
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderConfigDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackHeaderConfigDescriptor)
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
