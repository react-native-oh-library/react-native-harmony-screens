'use client';

import { Platform, View } from "react-native";
import React from "react";
import { ScreenContainerProps } from "react-native-screens/src/types";
import { isNativePlatformSupported, screensEnabled } from "../core";

// Native components
import ScreenContainerNativeComponent from "../specs/ScreenContainerNativeComponent";
import ScreenNavigationContainerNativeComponent from "../specs/ScreenNavigationContainerNativeComponent";

// RNOH patch: Context for HarmonyOS only
const ScreenOrderContext = React.createContext<{ getNextIndex: () => number } | null>(null);

function ScreenContainer(props: ScreenContainerProps) {
  const { enabled = screensEnabled(), hasTwoStates, style, children, ...rest } = props;
  const isHarmony = (Platform.OS as string) === "harmony";
  
  // RNOH patch: Track declaration order for HarmonyOS only
  const screenIndexRef = React.useRef(1);
  const getNextIndex = React.useCallback(() => screenIndexRef.current++, []);
  React.useEffect(() => { screenIndexRef.current = 1; }, [children]);
  const contextValue = React.useMemo(() => ({ getNextIndex }), [getNextIndex]);

  if (enabled && isNativePlatformSupported) {
    if (hasTwoStates) {
      const ScreenNavigationContainer =
        Platform.OS === "ios"
          ? ScreenNavigationContainerNativeComponent
          : ScreenContainerNativeComponent;
      const container = <ScreenNavigationContainer {...rest} style={isHarmony ? [{ position: "relative" as const }, style] : style}>{children}</ScreenNavigationContainer>;
      return isHarmony ? <ScreenOrderContext.Provider value={contextValue}>{container}</ScreenOrderContext.Provider> : container;
    }
    const container = <ScreenContainerNativeComponent {...rest} style={isHarmony ? [{ position: "relative" as const }, style] : style}>{children}</ScreenContainerNativeComponent>;
    return isHarmony ? <ScreenOrderContext.Provider value={contextValue}>{container}</ScreenOrderContext.Provider> : container;
  }
  const view = <View {...rest} style={isHarmony ? [{ position: "relative" as const }, style] : style}>{children}</View>;
  return isHarmony ? <ScreenOrderContext.Provider value={contextValue}>{view}</ScreenOrderContext.Provider> : view;
}

export { ScreenOrderContext };

export default ScreenContainer;
