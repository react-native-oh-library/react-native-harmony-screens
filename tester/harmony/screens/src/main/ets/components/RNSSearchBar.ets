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

import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { NATIVE_BUTTON_OFFSET, NATIVE_BUTTON_VERTICAL_EDGE_MARGIN } from '../Constants'

export type RNSSearchBarDescriptor = Descriptor<"RNSSearchBar", RNC.RNSSearchBar.Props>


@Component
export struct RNSSearchBar {
  public static readonly NAME = RNC.RNSSearchBar.NAME
  public ctx!: RNComponentContext
  public isFirstScreenInStack!: boolean
  public tag: number = 0
  @State descriptor: RNSSearchBarDescriptor = {} as RNSSearchBarDescriptor
  private cleanUpCallbacks: (() => void)[] = []
  private eventEmitter: RNC.RNSSearchBar.EventEmitter | undefined = undefined
  @State text: string = ''
  @State showTextInput: boolean = false;
  @State placeholder: string | undefined = undefined;
  @State backgroundColorValue: string | undefined = undefined;
  @State fontColor: string | undefined = undefined
  @State type: SearchType | undefined = undefined
  @State hintTextColor: string | undefined = undefined
  @State cancelIconVisiblilty: Visibility = Visibility.Visible
  @State cancelButtonText: string | undefined = undefined;
  @State headerIconColor: string | undefined = undefined
  @State shouldShowHintSearchIcon: boolean = true;
  private cleanupCommandCallback?: () => void = undefined;

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSSearchBar.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSSearchBarDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSSearchBarDescriptor)
        this.updateState()
      }
    ))
    this.updateState()
    this.cleanupCommandCallback = this.ctx.componentCommandReceiver.registerCommandCallback(
      this.tag,
      (command, args:ESObject[]) => {
        this.ctx.logger.info(this.tag, "ETS------------> command: " + command+',args'+args)
        if (command === 'open') {
          if (!this.showTextInput) {
            this.showTextInput = true;
          }
        } else if (command === 'close') {
          if (this.showTextInput) {
            this.getUIContext().getFocusController().clearFocus();
            this.showTextInput = false;
          }
        } else if (command === 'focus') {
          this.showTextInput = true;
          setTimeout(()=>{
            this.getUIContext().getFocusController().requestFocus("search");
          }, 50)
        } else if (command === 'blur') {
          this.getUIContext().getFocusController().clearFocus();
        } else if (command === 'setText') {
          this.text = args.toString();
        } else if (command === 'clearText') {
          this.text = "";
        } else if (command === 'toggleCancelButton') {
            if (args.toString() == 'true') {
              this.cancelIconVisiblilty = Visibility.Visible;
            } else {
              this.cancelIconVisiblilty = Visibility.None;
            }
        } else if (command === 'cancelSearch') {
          this.cancelSearch();
        }
      });
  }

  updateState() {
    if (!this.descriptor) {
      return;
    }
    if (this.placeholder !== this.descriptor.rawProps["placeholder"]) {
      this.placeholder = this.descriptor.rawProps["placeholder"];
    }
    if (this.backgroundColorValue !== (this.descriptor.rawProps["barTintColor"] || Color.Transparent)) {
      this.backgroundColorValue = this.descriptor.rawProps["barTintColor"] || Color.Transparent
    }
    if (this.fontColor !== this.descriptor.rawProps["textColor"]) {
      this.fontColor = this.descriptor.rawProps["textColor"];
    }
    if (this.type !== this.getInputType(this.descriptor.rawProps["inputType"])) {
      this.type = this.getInputType(this.descriptor.rawProps["inputType"])
    }
    if (this.hintTextColor !== this.descriptor.rawProps["hintTextColor"] || '#333333') {
      this.hintTextColor = this.descriptor.rawProps["hintTextColor"] || '#333333';
    }
    this.cancelButtonText = this.descriptor.rawProps["cancelButtonText"] || 'cancel';
    this.headerIconColor = this.descriptor.rawProps["headerIconColor"];
    this.shouldShowHintSearchIcon = this.descriptor.rawProps["shouldShowHintSearchIcon"]
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  getInputType(value: string): SearchType {
    switch (value) {
      case 'text':
        return SearchType.NORMAL
      case 'phone':
        return SearchType.PHONE_NUMBER
      case 'number':
        return SearchType.NUMBER
      case 'email':
        return SearchType.EMAIL
      default:
        return SearchType.NORMAL
    }
  }

  cancelSearch() {
    this.eventEmitter!.emit("cancelButtonPress", {})
    this.showTextInput = false;
  }

  build() {
    Column() {
      Row() {
        if (this.showTextInput) {
          Row() {
            Search({ placeholder: this.placeholder, value: this.text })
              .layoutWeight(1)
              .fontColor(this.fontColor)
              .placeholderColor(this.hintTextColor)
              .searchIcon({ color: this.headerIconColor, size: this.shouldShowHintSearchIcon?16:0 })
              .backgroundColor(this.backgroundColorValue)
	            .cancelButton({ style: CancelButtonStyle.CONSTANT, icon: { color: this.headerIconColor }})
              .type(this.type)
              .focusable(true)
              .onChange((value: string) => {
              this.text = value
              this.eventEmitter!.emit("changeText", { text: value })
            })
            .onFocus(() => {
              this.eventEmitter!.emit("searchFocus", {})
            })
            .onBlur(() => {
              this.eventEmitter!.emit("searchBlur", {})
            })
            .onSubmit(() => {
              this.eventEmitter?.emit("searchButtonPress", {
                text: this.text
                })
              })
            .id("search")
            Text(this.cancelButtonText)
              .padding({ left: 5 })
              .visibility(this.cancelIconVisiblilty)
              .onClick((e) => {
                if (this.text !== "") {
                  this.text = "";
                  this.eventEmitter!.emit("changeText", { text: this.text })
                }
                this.cancelSearch()
              })
          }.width(200)
          .justifyContent(FlexAlign.End)
        } else {
          SymbolGlyph($r('sys.symbol.magnifyingglass')).fontSize(26).onClick(() => {
            this.showTextInput = true;
            this.eventEmitter!.emit("open", {})
          })
        }
      }.justifyContent(FlexAlign.End)
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.End)
    .layoutWeight(1)
  }
}
