import {
  AnyJSBundleProvider,
  FileJSBundleProvider,
  ComponentBuilderContext,
  ResourceJSBundleProvider,
  RNApp,
  RNOHErrorDialog,
  MetroJSBundleProvider,
  TraceJSBundleProviderDecorator,
  RNOHCoreContext,
  RNOHLogger
} from "@rnoh/react-native-openharmony";
import { getRNOHPackages } from '../PackageProvider'
import {componentBuilder} from '@react-native-oh-tpl/react-native-openharmony-screens'


@Builder
export function buildCustomRNComponent(ctx: ComponentBuilderContext) {
  // There seems to be a problem with the placement of ArkTS components in mixed mode. Nested Stack temporarily avoided.
  Stack() {
    componentBuilder(ctx)
  }
  .position({ x: 0, y: 0 })

}
const wrappedCustomRNComponentBuilder = wrapBuilder(buildCustomRNComponent)

@Entry
@Component
struct Index {
  @StorageLink('RNOHCoreContext') rnohCoreContext: RNOHCoreContext | undefined = undefined
  @State shouldShow: boolean = false
  private logger!: RNOHLogger

  aboutToAppear() {
    this.logger = this.rnohCoreContext!.logger.clone("Index")
    const stopTracing = this.logger.clone("aboutToAppear").startTracing()
    this.shouldShow = true
    stopTracing()
  }

  onBackPress(): boolean | undefined {
    // NOTE: this is required since `Ability`'s `onBackPressed` function always
    // terminates or puts the app in the background, but we want Ark to ignore it completely
    // when handled by RN
    this.rnohCoreContext!.dispatchBackPress()
    return true
  }

  build() {
    Column() {
      Text("1233333333122 1212323")
      if (this.rnohCoreContext && this.shouldShow) {
        if (this.rnohCoreContext?.isDebugModeEnabled) {
          RNOHErrorDialog({ ctx: this.rnohCoreContext })
        }
        Text("222 1214442323")
        RNApp({
          rnInstanceConfig: {
            createRNPackages: getRNOHPackages,
            name: "app_name",
            enableNDKTextMeasuring: true,
            enableBackgroundExecutor: false,
            enableCAPIArchitecture: true,
            arkTsComponentNames: ["RNSScreen", "RNSFullWindowOverlay", "RNSModalScreen", "RNSScreenContainer", "RNSScreenNavigationContainer", "RNSScreenStack", "RNSScreenStackHeaderSubview", "RNSSearchBar", "RNSScreenStackHeaderConfig"],
          },
          initialProps: { "foo": "bar" } as Record<string, string>,
          appKey: "app_name",
          wrappedCustomRNComponentBuilder: wrappedCustomRNComponentBuilder,
          onSetUp: (rnInstance) => {
            rnInstance.enableFeatureFlag("ENABLE_RN_INSTANCE_CLEAN_UP")
          },
          // jsBundleProvider: new TraceJSBundleProviderDecorator(
          //   new MetroJSBundleProvider(),
          //   this.rnohCoreContext.logger),

          jsBundleProvider: new TraceJSBundleProviderDecorator(
            new AnyJSBundleProvider([
              new MetroJSBundleProvider(),
              // NOTE: to load the bundle from file, place it in
              // `/data/app/el2/100/base/com.rnoh.tester/files/bundle.harmony.js`
              // on your device. The path mismatch is due to app sandboxing on HarmonyOS
              new FileJSBundleProvider('/data/storage/el2/base/files/bundle.harmony.js'),
              // new FileJSBundleProvider(context.filesDir + '/' + this.bundlePath),
              new ResourceJSBundleProvider(this.rnohCoreContext.uiAbilityContext.resourceManager, 'hermes_bundle.hbc'),
              new ResourceJSBundleProvider(this.rnohCoreContext.uiAbilityContext.resourceManager, 'bundle.harmony.js')
            ]),
            this.rnohCoreContext.logger),
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}
