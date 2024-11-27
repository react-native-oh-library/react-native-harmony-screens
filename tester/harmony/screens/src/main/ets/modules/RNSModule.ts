import { UITurboModule, UITurboModuleContext, } from '@rnoh/react-native-openharmony/ts';
import { TM } from '@rnoh/react-native-openharmony/generated/ts';

export class RNSModule extends UITurboModule implements TM.RNSModule.Spec {
  static readonly NAME: string = TM.RNSModule.NAME

  constructor(ctx: UITurboModuleContext) {
    super(ctx);
  }
}
