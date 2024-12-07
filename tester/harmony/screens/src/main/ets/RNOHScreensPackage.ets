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

export class RNOHScreensPackage extends RNOHPackage {
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
