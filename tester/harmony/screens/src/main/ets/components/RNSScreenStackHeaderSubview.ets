import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { RNSSearchBar } from './RNSSearchBar';
import { NATIVE_BUTTON_OFFSET } from '../Constants'

export type RNSScreenStackHeaderSubviewDescriptor = Descriptor<"RNSScreenStackHeaderSubview", RNC.RNSScreenStackHeaderSubview.Props>

@Component
export struct RNSScreenStackHeaderSubview {
  public static readonly NAME = RNC.RNSScreenStackHeaderSubview.NAME
  public ctx!: RNComponentContext
  public tag!: number
  public isFirstScreenInStack!: boolean
  @State descriptor: RNSScreenStackHeaderSubviewDescriptor | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  @State alignment: HorizontalAlign = HorizontalAlign.Center
  @State isSearchBar: boolean = false
  @State searchBarTag: number = -1

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackHeaderSubviewDescriptor)
        this.updateState()
      }
    ))
    this.updateState()
  }

  updateState() {
    if (!this.descriptor) {
      return;
    }
    this.alignment = this.horizontalAlignFromString(this.descriptor.rawProps["type"])
    this.isSearchBar = this.descriptor.childrenTags.some((childTag) => {
      const tmpDesc = this.ctx.descriptorRegistry.getDescriptor<Descriptor>(childTag)
      if (tmpDesc && tmpDesc.type === "RNSSearchBar") {
        this.searchBarTag = childTag
        this.alignment = HorizontalAlign.End
        return true
      }
      return false
    })
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
    if (this.isSearchBar) {
      RNSSearchBar({
        ctx: this.ctx,
        tag: this.searchBarTag,
        isFirstScreenInStack: this.isFirstScreenInStack
      })
    } else {
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
}
