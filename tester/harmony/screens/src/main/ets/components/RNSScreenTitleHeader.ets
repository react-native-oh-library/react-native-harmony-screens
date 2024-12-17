import { RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview, RNSScreenStackHeaderSubviewDescriptor } from './RNSScreenStackHeaderSubview';
import { TITLEBAR_HEIGHT, NATIVE_BUTTON_VERTICAL_EDGE_MARGIN } from '../Constants';

@Component
export struct RNSScreenTitleHeader {
  public ctx!: RNComponentContext
  public isFirstScreenInStack!: boolean
  public screenStackHeaderConfigTag!: number
  @State descriptor: RNSScreenStackHeaderConfigDescriptor | undefined = undefined
  @State nativeTitleText: string = "";
  @State fontFamilyValue: string | undefined = undefined;
  @State titleFontSizeValue: string | undefined = undefined;
  @State titleFontWeightValue: string | undefined = undefined;
  @State titleColorValue: string | undefined = undefined;
  private cleanUpCallbacks: (() => void)[] = []

  aboutToAppear(): void {
    this.descriptor =
      this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderConfigDescriptor>(this.screenStackHeaderConfigTag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.screenStackHeaderConfigTag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenStackHeaderConfigDescriptor)
        this.updateState()
      }))
    this.updateState()
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  updateState() {
    if (!this.descriptor) {
      return
    }
    const shouldDisplayNativeTitle = this.descriptor.childrenTags.length > 0 ?
    this.descriptor.childrenTags.every((e) => {
      const tmpDesc = this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderSubviewDescriptor>(e)
      if (tmpDesc.rawProps["type"] === "title" || tmpDesc.rawProps["type"] === "center" ||
        tmpDesc.rawProps["type"] === "left") {
        return false;
      }
      return true;
    }) : true;

    const newNativeTitleText: string = shouldDisplayNativeTitle ? this.descriptor.rawProps["title"] : " ";
    if (this.nativeTitleText !== newNativeTitleText) {
      this.nativeTitleText = newNativeTitleText;
    }
    if (this.fontFamilyValue !== this.descriptor.rawProps["titleFontFamily"]) {
      this.fontFamilyValue = this.descriptor.rawProps["titleFontFamily"]
    }
    if (this.titleFontSizeValue !== this.descriptor.rawProps["titleFontSize"]) {
      this.titleFontSizeValue = this.descriptor.rawProps["titleFontSize"]
    }
    if (this.titleFontWeightValue !== this.descriptor.rawProps["titleFontWeight"]) {
      this.titleFontWeightValue = this.descriptor.rawProps["titleFontWeight"]
    }
    if (this.titleColorValue !== this.descriptor.rawProps["titleColor"]) {
      this.titleColorValue = this.descriptor.rawProps["titleColor"]
    }
  }

  build() {
    Stack() {
      Text(this.nativeTitleText)
        .width("100%")
        .height("100%")
        .offset({
          left: TITLEBAR_HEIGHT + NATIVE_BUTTON_VERTICAL_EDGE_MARGIN
        })
        .fontFamily(this.fontFamilyValue)
        .fontSize(this.titleFontSizeValue)
        .fontWeight(this.titleFontWeightValue)
        .fontColor(this.titleColorValue)
        .textAlign(TextAlign.Start)
      if (this.descriptor) {
        ForEach(this.descriptor.childrenTags, (childTag: number) => {
          RNSScreenStackHeaderSubview({
            ctx: this.ctx,
            tag: childTag,
            isFirstScreenInStack: this.isFirstScreenInStack
          })
        })
      }
    }
    .width("100%")
    .height("100%")
    .hitTestBehavior(HitTestMode.Transparent)
    .offset({
      right: TITLEBAR_HEIGHT
    })
  }
}
