import React from 'react';
import { ViewProps } from 'react-native';
import ScreenContentWrapperNativeComponent from '../specs/ScreenContentWrapperNativeComponent';

function ScreenContentWrapper(props: ViewProps) {
  return <ScreenContentWrapperNativeComponent collapsable={false} {...props} />;
}

export default ScreenContentWrapper;
