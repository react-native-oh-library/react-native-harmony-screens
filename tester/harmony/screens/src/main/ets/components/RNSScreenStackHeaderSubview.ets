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
  @State searchBarTag: number | undefined = -1
  @State subviewType: string | undefined = undefined

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
    this.subviewType = this.descriptor.rawProps["type"];
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
    if (this.subviewType && this.subviewType === 'searchBar') {
      RNSSearchBar({
        ctx: this.ctx,
        tag: this.searchBarTag,
        isFirstScreenInStack: this.isFirstScreenInStack
      })
    } else if (this.subviewType !== 'searchBar') {
      Column() {
        Stack() {
          ContentSlot(this.ctx.getContentForTag(this.tag))
        }
      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.Center)
      .alignItems(this.alignment)
    }
  }
}
