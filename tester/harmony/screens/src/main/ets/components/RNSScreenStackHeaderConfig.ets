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
