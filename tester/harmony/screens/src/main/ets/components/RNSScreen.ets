import { Descriptor, ViewBaseProps, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"


interface RNSScreenProps extends ViewBaseProps {
  size: number
}

export type RNSScreenDescriptor = Descriptor<"RNSScreen", RNSScreenProps>

@Component
export struct RNSScreen {
  public static readonly NAME = RNC.RNSScreen.NAME
  public ctx!: RNComponentContext
  public tag: number = 0
  @State descriptor: RNSScreenDescriptor = {} as RNSScreenDescriptor
  private eventEmitter: RNC.RNSScreen.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  private dismissCount: number = 0;

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSScreen.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenDescriptor)
      }
    ))
    this.eventEmitter!.emit("willAppear", {})
  }

  aboutToDisappear() {
    this.eventEmitter!.emit("willDisappear", {})
    this.cleanUpCallbacks.forEach(cb => cb())
    // TODO: check for possible bugs
    this.dismissCount = 1;
  }

  build() {
    Stack() {
      ContentSlot(this.ctx.getContentForTag(this.tag))
    }
    .onAppear(() => this.eventEmitter!.emit("appear", {}))
    .onDisAppear(() => this.eventEmitter!.emit("disappear", {}))
    .onDetach(() => this.eventEmitter!.emit("dismissed", {
      dismissCount: this.dismissCount
    }))
  }
}