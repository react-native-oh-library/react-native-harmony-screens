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

import { ComponentBuilderContext, RNOHPackage, RNPackageContext } from "@rnoh/react-native-openharmony";
import type { UITurboModule, UITurboModuleContext } from "@rnoh/react-native-openharmony/ts";
import { RNSScreen } from './components/RNSScreen';
import { RNSFullWindowOverlay } from './components/RNSFullWindowOverlay';
import { RNSModalScreen } from './components/RNSModalScreen';
import { RNSScreenContainer } from './components/RNSScreenContainer';
import { RNSScreenNavigationContainer } from './components/RNSScreenNavigationContainer';
import { RNSScreenStack } from './components/RNSScreenStack';
import { RNSScreenStackHeaderSubview } from './components/RNSScreenStackHeaderSubview';
import { RNSScreenStackHeaderConfig } from './components/RNSScreenStackHeaderConfig'
import { RNSSearchBar } from './components/RNSSearchBar';

import { RNSModule } from './modules/RNSModule'

@Builder
export function componentBuilder(ctx: ComponentBuilderContext) {
  if (ctx.componentName == RNSScreen.NAME) {
    RNSScreen({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSFullWindowOverlay.NAME) {
    RNSFullWindowOverlay({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSModalScreen.NAME) {
    RNSModalScreen({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSScreenContainer.NAME) {
    RNSScreenContainer({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSScreenNavigationContainer.NAME) {
    RNSScreenNavigationContainer({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSScreenStack.NAME) {
    RNSScreenStack({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSScreenStackHeaderSubview.NAME) {
    RNSScreenStackHeaderSubview({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSSearchBar.NAME) {
    RNSSearchBar({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  } else if (ctx.componentName == RNSScreenStackHeaderConfig.NAME) {
    RNSScreenStackHeaderConfig({
      ctx: ctx.rnComponentContext,
      tag: ctx.tag,
    })
  }
}

export default class RNOHScreensPackage extends RNOHPackage {
  private isRNScreensDevModeEnabled: boolean

  constructor(ctx: RNPackageContext, isRNScreensDevModeEnabled: boolean = false) {
    super(ctx)
    this.isRNScreensDevModeEnabled = isRNScreensDevModeEnabled
  }

  getUITurboModuleFactoryByNameMap(): Map<string, (ctx: UITurboModuleContext) => UITurboModule | null> {
    return new Map().set(RNSModule.NAME, (ctx: UITurboModuleContext) => new RNSModule(ctx))
  }

  createWrappedCustomRNComponentBuilderByComponentNameMap(): Map<string, WrappedBuilder<[ComponentBuilderContext]>> {
    return new Map()
      // FIXME: react-native-screens will be used mostly with navigation libraries which will use RNSScreenContainer
      // or RNSScreenStack, however there might be a need for using Screens component independently. Commenting that
      // line out ensures, that only one RNSScreen instance is created, otherwise one would be created by ScreenContainer
      // and another by the React mutation.
      // .set(RNSScreen.NAME, wrapBuilder(componentBuilder))
      .set(RNSFullWindowOverlay.NAME, wrapBuilder(componentBuilder))
      .set(RNSModalScreen.NAME, wrapBuilder(componentBuilder))
      .set(RNSScreenContainer.NAME, wrapBuilder(componentBuilder))
      .set(RNSScreenNavigationContainer.NAME, wrapBuilder(componentBuilder))
      .set(RNSScreenStack.NAME, wrapBuilder(componentBuilder))
      .set(RNSScreenStackHeaderSubview.NAME, wrapBuilder(componentBuilder))
      .set(RNSScreenStackHeaderConfig.NAME, wrapBuilder(componentBuilder))
      .set(RNSSearchBar.NAME, wrapBuilder(componentBuilder))
  }
}
