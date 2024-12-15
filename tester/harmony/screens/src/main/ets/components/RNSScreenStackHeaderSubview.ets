import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSScreenStackHeaderSubviewDescriptor = Descriptor<"RNSScreenStackHeaderSubview", RNC.RNSScreenStackHeaderSubview.Props>

const NATIVE_BUTTON_OFFSET = 52

@Component
export struct RNSScreenStackHeaderSubview {
  public static readonly NAME = RNC.RNSScreenStackHeaderSubview.NAME
  public ctx!: RNComponentContext
  public tag!: number
  @State descriptor: RNSScreenStackHeaderSubviewDescriptor = {} as RNSScreenStackHeaderSubviewDescriptor
  private cleanUpCallbacks: (() => void)[] = []
  @State alignment: HorizontalAlign = HorizontalAlign.Center

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackHeaderSubviewDescriptor)
        this.alignment = this.horizontalAlignFromString(this.descriptor.rawProps["type"])
      }
    ))
    this.alignment = this.horizontalAlignFromString(this.descriptor.rawProps["type"])
  }

  horizontalAlignFromString(value: string): HorizontalAlign {
    switch (value) {
      case "right":
      case "searchBar":
        return HorizontalAlign.End
      case "left":
      case "back":
        return HorizontalAlign.Start
      case "title":
      case "center":
        return HorizontalAlign.Center
      default:
        return HorizontalAlign.End
    }
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  build() {
    Column() {
      Stack() {
        ContentSlot(this.ctx.getContentForTag(this.tag))
      }
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .alignItems(this.alignment)
    .margin({
      left: this.alignment === HorizontalAlign.Start ? NATIVE_BUTTON_OFFSET : 0,
      right: this.alignment === HorizontalAlign.End ? NATIVE_BUTTON_OFFSET : 0,
    })
  }
}
