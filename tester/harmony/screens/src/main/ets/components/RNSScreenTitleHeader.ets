/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview, RNSScreenStackHeaderSubviewDescriptor } from './RNSScreenStackHeaderSubview';
import { TITLEBAR_HEIGHT, NATIVE_BUTTON_VERTICAL_EDGE_MARGIN, NATIVE_BUTTON_OFFSET } from '../Constants';

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
  @State backgroundColorValue: string | undefined = undefined;
  @State isTitleBarHidden: boolean = false;
  @State hideShadow: boolean = false;
  @State backTitle: string | undefined = undefined;
  @State backTitleFontFamily: string | undefined = undefined;
  @State backTitleFontSize: number | undefined = undefined;
  @State backTitleVisible: boolean | undefined = undefined;
  @State hideBackButton: boolean | undefined = undefined;
  @State backButtonInCustomView: boolean | undefined = undefined;
  @State titleBarTranslucent: boolean = false;
  private cleanUpCallbacks: (() => void)[] = []
  public backBtnPressed: () => void = () => {
  }

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
    this.hideShadow = this.descriptor.rawProps["hideShadow"];
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
    if (this.backgroundColorValue !== this.descriptor.rawProps["backgroundColor"]) {
      this.backgroundColorValue = this.descriptor.rawProps["backgroundColor"] || "#ffffff"
    }

    if (this.backTitle !== this.descriptor.rawProps["backTitle"]) {
      this.backTitle = this.descriptor.rawProps["backTitle"]
    }

    if (this.backTitleFontFamily !== this.descriptor.rawProps["backTitleFontFamily"]) {
      this.backTitleFontFamily = this.descriptor.rawProps["backTitleFontFamily"]
    }

    if (this.backTitleFontSize !== this.descriptor.rawProps["backTitleFontSize"]) {
      this.backTitleFontSize = this.descriptor.rawProps["backTitleFontSize"]
    }

    if (this.backTitleVisible !== this.descriptor.rawProps["backTitleVisible"]) {
      this.backTitleVisible = this.descriptor.rawProps["backTitleVisible"]
    }

    if (this.hideBackButton !== this.descriptor.rawProps["hideBackButton"]) {
      this.hideBackButton = this.descriptor.rawProps["hideBackButton"]
    }

    if (this.backButtonInCustomView !== this.descriptor.rawProps["backButtonInCustomView"]) {
      this.backButtonInCustomView = this.descriptor.rawProps["backButtonInCustomView"]
    }

    if (this.titleBarTranslucent !== this.descriptor.rawProps["translucent"]) {
      this.titleBarTranslucent = this.descriptor.rawProps["translucent"];
    }
  }

  build() {
    Column() {
      Stack() {
        Row() {
          if (!this.isFirstScreenInStack) {
            Row() {
              SymbolGlyph($r('sys.symbol.arrow_left')).fontSize(26).fontColor([this.titleColorValue])
                .visibility(this.hideBackButton ? Visibility.None : Visibility.Visible)

              if (this.backTitleVisible) {
                Text(this.backTitle ? this.backTitle : '')
                  .fontFamily(this.backTitleFontFamily)
                  .fontSize(this.backTitleFontSize ? this.backTitleFontSize : 18)
                  .fontColor(this.titleColorValue)
                  .margin({ left: this.hideBackButton ? 0 : 5, right: (this.backTitleVisible && this.backTitle) ? 5 : 0 })
              }
            }.height(56)
            .onClick(() => {
              if (this.backBtnPressed) {
                this.backBtnPressed();
              }
            })
          }
          Text(this.nativeTitleText)
            .height("100%")
            .fontFamily(this.fontFamilyValue)
            .fontSize(this.titleFontSizeValue ? this.titleFontSizeValue : 18)
            .fontWeight(this.titleFontWeightValue ? this.titleFontWeightValue : FontWeight.Medium)
            .fontColor(this.titleColorValue)
            .textAlign(TextAlign.Start)
        }
        .width("100%")
        .height("100%")
        .layoutWeight(1)
        .hitTestBehavior(HitTestMode.Transparent)

        Stack() {
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
        .layoutWeight(1)
        .hitTestBehavior(HitTestMode.Transparent)

      }.width("100%")
      .height(56)
      .layoutWeight(1)
      .padding({ left: 10, right: 10 })
      .backgroundColor(this.titleBarTranslucent?Color.Transparent:this.backgroundColorValue)
    }
    .width("100%")
    .height(56)
    .layoutWeight(1)
    .hitTestBehavior(HitTestMode.Transparent)
  }
}
