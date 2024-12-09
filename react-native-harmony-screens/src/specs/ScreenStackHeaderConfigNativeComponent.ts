import codegenNativeComponent from "react-native/Libraries/Utilities/codegenNativeComponent";
import type { ViewProps, ColorValue } from "react-native";
import type {
  Int32,
  WithDefault,
  DirectEventHandler,
} from "react-native/Libraries/Types/CodegenTypes";

// RNOH Patch
type DirectionType = "inherit" | "ltr" | "rtl";

// eslint-disable-next-line @typescript-eslint/ban-types
type OnAttachedEvent = Readonly<{}>;
// eslint-disable-next-line @typescript-eslint/ban-types
type OnDetachedEvent = Readonly<{}>;

type BackButtonDisplayMode = "minimal" | "default" | "generic";

export interface NativeProps extends ViewProps {
  onAttached?: DirectEventHandler<OnAttachedEvent>;
  onDetached?: DirectEventHandler<OnDetachedEvent>;
  backgroundColor?: ColorValue;
  backTitle?: string; // doesn't work on HarmonyOS
  backTitleFontFamily?: string;
  backTitleFontSize?: Int32;
  backTitleVisible?: WithDefault<boolean, "true">;
  color?: ColorValue;
  direction?: WithDefault<DirectionType, "ltr">;
  hidden?: boolean;
  hideShadow?: boolean;
  largeTitle?: boolean; // iOS only
  largeTitleFontFamily?: string; // iOS only
  largeTitleFontSize?: Int32; // iOS only
  largeTitleFontWeight?: string; // iOS only
  largeTitleBackgroundColor?: ColorValue; // iOS only
  largeTitleHideShadow?: boolean; // iOS only
  largeTitleColor?: ColorValue; // iOS only
  translucent?: boolean;
  title?: string;
  titleFontFamily?: string;
  titleFontSize?: Int32;
  titleFontWeight?: string;
  titleColor?: ColorValue;
  disableBackButtonMenu?: boolean; // iOS only
  backButtonDisplayMode?: WithDefault<BackButtonDisplayMode, "default">;
  hideBackButton?: boolean; // doesn't work on HarmonyOS
  backButtonInCustomView?: boolean;
  // TODO: implement this props on iOS
  topInsetEnabled?: boolean;
}

export default codegenNativeComponent<NativeProps>(
  "RNSScreenStackHeaderConfig",
  {}
);
