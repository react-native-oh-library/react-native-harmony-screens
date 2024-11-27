import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSScreenNavigationContainerProps extends ViewBaseProps {
  size: number
}

export type RNSScreenNavigationContainerDescriptor = Descriptor<"RNSScreenNavigationContainer", RNSScreenNavigationContainerProps>

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
    Stack() {
      ContentSlot(this.ctx.getContentForTag(this.tag))
    }
  }
}
