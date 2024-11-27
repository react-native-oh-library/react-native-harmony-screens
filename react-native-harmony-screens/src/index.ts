// Side effects import declaration to ensure our TurboModule
// is loaded.
import "./specs/NativeScreensModule";

export * from "react-native-screens/src/types";

/**
 * Core
 */
export {
  enableScreens,
  enableFreeze,
  screensEnabled,
  freezeEnabled,
} from "react-native-screens/src/core";

/**
 * RNS Components
 */
export {
  default as Screen,
  InnerScreen,
  ScreenContext,
} from "./components/Screen";

export {
  ScreenStackHeaderConfig,
  ScreenStackHeaderSubview,
  ScreenStackHeaderLeftView,
  ScreenStackHeaderCenterView,
  ScreenStackHeaderRightView,
  ScreenStackHeaderBackButtonImage,
  ScreenStackHeaderSearchBarView,
} from "react-native-screens/src/components/ScreenStackHeaderConfig";

export { default as SearchBar } from "react-native-screens/src/components/SearchBar";
export { default as ScreenContainer } from "react-native-screens/src/components/ScreenContainer";
export { default as ScreenStack } from "react-native-screens/src/components/ScreenStack";
export { default as ScreenStackItem } from "react-native-screens/src/components/ScreenStackItem";
export { default as FullWindowOverlay } from "react-native-screens/src/components/FullWindowOverlay";
export { default as ScreenFooter } from "react-native-screens/src/components/ScreenFooter";
export { default as ScreenContentWrapper } from "react-native-screens/src/components/ScreenContentWrapper";

/**
 * Utils
 */
export {
  isSearchBarAvailableForCurrentPlatform,
  compatibilityFlags,
  executeNativeBackPress,
} from "react-native-screens/src/utils";

/**
 * Hooks
 */
export { default as useTransitionProgress } from "react-native-screens/src/useTransitionProgress";
