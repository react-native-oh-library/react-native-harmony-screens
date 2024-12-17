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
