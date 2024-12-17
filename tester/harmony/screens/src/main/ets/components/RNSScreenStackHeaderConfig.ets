import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenStackHeaderConfigDescriptor = Descriptor<"RNSScreenStackHeaderConfig", RNC.RNSScreenStackHeaderConfig.Props>

@Component
export struct RNSScreenStackHeaderConfig {
  public static readonly NAME = RNC.RNSScreenStackHeaderConfig.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenStackHeaderConfigDescriptor = {} as RNSScreenStackHeaderConfigDescriptor
  private cleanUpCallbacks: (() => void)[] = []
  private eventEmitter: RNC.RNSScreenStackHeaderConfig.EventEmitter | undefined = undefined

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSScreenStackHeaderConfig.EventEmitter(this.ctx.rnInstance, this.tag)
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
    }.onAttach(() => {
      this.eventEmitter!.emit("attached", {});
    }).onDetach(() => {
      this.eventEmitter!.emit("detached", {});
    })
  }
}
