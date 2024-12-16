import { RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview, RNSScreenStackHeaderSubviewDescriptor } from './RNSScreenStackHeaderSubview';

const TITLEBAR_HEIGHT = 56;

@Component
export struct RNSScreenHeader {
  public ctx!: RNComponentContext
  public isFirstScreenInStack!: boolean
  @Watch('onDescriptorChange') @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor =
    {} as RNSScreenStackHeaderConfigDescriptor
  @State nativeTitleText: string = "";

  aboutToAppear(): void {
    this.onDescriptorChange()
  }

  onDescriptorChange() {
    const shouldDisplayNativeTitle = this.screenStackHeaderConfigDescriptor.childrenTags.length > 0 ?
    this.screenStackHeaderConfigDescriptor.childrenTags.map((e) => {
      const tmpDesc = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(e)
      if (tmpDesc.rawProps["type"] === "title" || tmpDesc.rawProps["type"] === "center" ||
        tmpDesc.rawProps["type"] === "left") {
        return false;
      }
      return true;
    }).every((value) => value === true) : true;
    this.nativeTitleText = shouldDisplayNativeTitle ? this.screenStackHeaderConfigDescriptor.rawProps["title"] : " ";
  }

  build() {
    Stack() {
      Text(this.nativeTitleText)
        .width("100%")
        .height("100%")
        .offset({
          left: TITLEBAR_HEIGHT + 8
        })
        .fontFamily(this.screenStackHeaderConfigDescriptor.rawProps["titleFontFamily"])
        .fontSize(this.screenStackHeaderConfigDescriptor.rawProps["titleFontSize"])
        .fontWeight(this.screenStackHeaderConfigDescriptor.rawProps["titleFontWeight"])
        .fontColor(this.screenStackHeaderConfigDescriptor.rawProps["titleColor"])
        .textAlign(TextAlign.Start)
      ForEach(this.screenStackHeaderConfigDescriptor.childrenTags, (childTag: number) => {
        RNSScreenStackHeaderSubview({
          ctx: this.ctx,
          tag: childTag,
          isFirstScreenInStack: this.isFirstScreenInStack
        })
      })
    }
    .width("100%")
    .height("100%")
    .hitTestBehavior(HitTestMode.Transparent)
    .offset({
      right: TITLEBAR_HEIGHT
    })
  }
}
