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

import window from '@ohos.window';
import { RNComponentContext } from '@rnoh/react-native-openharmony';

interface EdgeInsets {
  top: number,
  bottom: number,
  left: number,
  right: number
}

export class SafeAreaInsets {
  protected windowInstance: window.Window | null = null;
  protected ctx: RNComponentContext;

  constructor(ctx: RNComponentContext) {
    this.ctx = ctx;
  }

  getSafeAreaInsets(): Promise<EdgeInsets> {
    return new Promise(async (resolve, reject) => {
      try {
        const windowInstance = await window.getLastWindow(
          this.ctx.uiAbilityContext,
        );
        const windowInfo = windowInstance.getWindowProperties();
        if (!windowInfo.isLayoutFullScreen) {
          const insets: EdgeInsets = {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          };
          resolve(insets);
        } else {
          let type = window.AvoidAreaType.TYPE_SYSTEM;
          let avoidArea = windowInstance.getWindowAvoidArea(type);
          const avoidAreaBottom = this.windowInstance?.getWindowAvoidArea(
            window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR,
          );
          const insets: EdgeInsets = {
            top: px2vp(avoidArea.topRect.height),
            right: px2vp(avoidArea.rightRect.height),
            bottom: px2vp(avoidAreaBottom?.bottomRect.height),
            left: px2vp(avoidArea.leftRect.height),
          };
          resolve(insets);
        }
      } catch (exception) {
        reject(exception);
      }
    });
  }
}
