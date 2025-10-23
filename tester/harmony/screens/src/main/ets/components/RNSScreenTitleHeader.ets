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
  @State isFirstScreenInStack: boolean  = true;
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
  @State blurEffect: 'none' | 'extraLight' | 'light' | 'dark' | 'regular' | 'prominent' | 'systemUltraThinMaterial' | 'systemThinMaterial' | 'systemMaterial' | 'systemThickMaterial' | 'systemChromeMaterial' | 'systemUltraThinMaterialLight' | 'systemThinMaterialLight' | 'systemMaterialLight' | 'systemThickMaterialLight' | 'systemChromeMaterialLight' | 'systemUltraThinMaterialDark' | 'systemThinMaterialDark' | 'systemMaterialDark' | 'systemThickMaterialDark' | 'systemChromeMaterialDark' = 'none';
  @State blueStyle: BlurStyle = BlurStyle.NONE;
  @State hintColor: string | undefined = undefined;
  @State isTranslate: boolean = false; // 背景色是否有alpha透明度

  private cleanUpCallbacks: (() => void)[] = []
  public backBtnPressed: () => void = () => {
  }

  aboutToAppear(): void {
    if(!!!this.screenStackHeaderConfigTag) {
      return;
    }
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

  blurEffectConvert(){
    if(this.blurEffect){
      switch(this.blurEffect) {
        case 'none':
          this.blueStyle = BlurStyle.NONE;
          break;
        case 'extraLight':
          this.blueStyle = BlurStyle.BACKGROUND_THIN;
          break;
        case 'light':
          this.blueStyle = BlurStyle.BACKGROUND_THICK;
          break;
        case 'dark':
          this.blueStyle = BlurStyle.BACKGROUND_ULTRA_THICK;
          break;
        case 'regular':
          this.blueStyle = BlurStyle.BACKGROUND_REGULAR;
          break;
        case 'prominent':
        case 'systemMaterial':
        case 'systemMaterialLight':
        case 'systemMaterialDark':
        case 'systemUltraThinMaterial':
        case 'systemUltraThinMaterialLight':
        case 'systemUltraThinMaterialDark':
        case 'systemThinMaterial':
        case 'systemThinMaterialLight':
        case 'systemThinMaterialDark':
        case 'systemThickMaterial':
        case 'systemThickMaterialLight':
        case 'systemThickMaterialDark':
        case 'systemChromeMaterial':
        case 'systemChromeMaterialLight':
        case 'systemChromeMaterialDark':
          this.ctx.logger.error('RNSScreenStackHeaderConfig', this.blurEffect+" not support")
          break;
      }
    }
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

    if (this.blurEffect !== this.descriptor.rawProps["blurEffect"]) {
      this.blurEffect = this.descriptor.rawProps["blurEffect"];
    }

    let tmpColor: string | undefined  = this.descriptor.rawProps["color"];
    if (this.hintColor !== tmpColor) {
      this.hintColor = tmpColor;
    }

    let tmpTitleColor: string | undefined  = this.descriptor.rawProps["titleColor"];
    if (this.titleColorValue !== tmpTitleColor) {
      this.titleColorValue = tmpTitleColor;
    }

    this.isTranslate = hasTransparency(this.backgroundColorValue);
    this.blurEffectConvert();
  }

  build() {
    RelativeContainer() {
      if(this.screenStackHeaderConfigTag){
      Stack() {
        Row() {
            if (!this.isFirstScreenInStack && !this.hideBackButton) {
            Row() {
              SymbolGlyph($r('sys.symbol.arrow_left')).fontSize(26).fontColor([this.hintColor])

              if (this.backTitleVisible) {
                Text(this.backTitle ? this.backTitle : '')
                  .fontFamily(this.backTitleFontFamily)
                  .fontSize(this.backTitleFontSize ? this.backTitleFontSize : 18)
                  .fontColor(this.hintColor)
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
            .fontColor(this.titleColorValue?this.titleColorValue:this.hintColor)
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
      .backgroundBlurStyle(this.isTranslate?this.blueStyle:BlurStyle.NONE)

      Text('')
        .width("100%")
        .height("1")
        .backgroundColor('#d3d3d3')
        .visibility(this.hideShadow ? Visibility.None : Visibility.Visible)
        .alignRules({
          start: { anchor: "__container__", align: HorizontalAlign.Start },
          top: { anchor: "__container__", align: VerticalAlign.Bottom }
        })
      }
    }
    .width("100%")
    .height(56)
    .layoutWeight(1)
    .hitTestBehavior(HitTestMode.Transparent)
  }
}

export function hasTransparency(color: string| undefined): boolean {
  if (!!!color) {
    return false;
  }
  // 移除所有空格并转为小写
  const normalizedColor = color.replace(/\s/g, '').toLowerCase();

  // 检查 RGBA
  const rgbaMatch = normalizedColor.match(/rgba\([^)]+,\s*([\d.]+)\)/);
  if (rgbaMatch) {
    return parseFloat(rgbaMatch[1]) < 1;
  }

  // 检查 HSLA
  const hslaMatch = normalizedColor.match(/hsla\([^)]+,\s*([\d.]+)\)/);
  if (hslaMatch) {
    return parseFloat(hslaMatch[1]) < 1;
  }

  // 检查 8 位 HEX
  const hexMatch = normalizedColor.match(/^#([a-f0-9]{8})$/);
  if (hexMatch) {
    const alphaHex = hexMatch[1].substring(6, 8);
    return parseInt(alphaHex, 16) < 255;
  }

  // 检查 4 位 HEX（简写格式）
  const shortHexMatch = normalizedColor.match(/^#([a-f0-9]{4})$/);
  if (shortHexMatch) {
    const alphaHex = shortHexMatch[1].charAt(3) + shortHexMatch[1].charAt(3);
    return parseInt(alphaHex, 16) < 255;
  }

  if (normalizedColor === 'translate') {
    return true;
  }

  // 没有透明度信息或格式不支持
  return false;
}
