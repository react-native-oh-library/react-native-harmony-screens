"use client";

import { Platform, View } from "react-native";
import React from "react";
import { ScreenContainerProps } from "react-native-screens/src/types";
import { isNativePlatformSupported, screensEnabled } from "../core";

// Native components
import ScreenContainerNativeComponent from "../specs/ScreenContainerNativeComponent";
import ScreenNavigationContainerNativeComponent from "../specs/ScreenNavigationContainerNativeComponent";

function ScreenContainer(props: ScreenContainerProps) {
  const { enabled = screensEnabled(), hasTwoStates, ...rest } = props;

  if (enabled && isNativePlatformSupported) {
    if (hasTwoStates) {
      const ScreenNavigationContainer =
        Platform.OS === "ios"
          ? ScreenNavigationContainerNativeComponent
          : ScreenContainerNativeComponent;
      return <ScreenNavigationContainer {...rest} />;
    }
    return <ScreenContainerNativeComponent {...rest} />;
  }
  return <View {...rest} />;
}

export default ScreenContainer;
