import React from 'react';
import { GestureProviderProps } from 'react-native-screens/src/types';
import { GHContext } from 'react-native-screens/src/contexts';
import ScreenGestureDetector from './ScreenGestureDetector';

function GHWrapper(props: GestureProviderProps) {
  return <ScreenGestureDetector {...props} />;
}

export default function GestureDetectorProvider(props: {
  children: React.ReactNode;
}) {
  return (
    <GHContext.Provider value={GHWrapper}>{props.children}</GHContext.Provider>
  );
}
