import { RNOHPackage, RNPackageContext } from "@rnoh/react-native-openharmony";
import type { UITurboModule, UITurboModuleContext } from "@rnoh/react-native-openharmony/ts";

export class RNOHScreensPackage extends RNOHPackage {
  private isRNScreensDevModeEnabled: boolean

  constructor(ctx: RNPackageContext, isRNScreensDevModeEnabled: boolean = false) {
    super(ctx)
    this.isRNScreensDevModeEnabled = isRNScreensDevModeEnabled
  }

  getUITurboModuleFactoryByNameMap(): Map<string, (ctx: UITurboModuleContext) => UITurboModule | null> {
    return new Map();
  }
}
