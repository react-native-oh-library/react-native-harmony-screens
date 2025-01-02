import type { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony';
import { createRNOHPackages as createRNOHPackagesAutolinking } from "./RNOHPackagesFactory"
import RNOHScreensPackage from "@react-native-oh-tpl/react-native-openharmony-screens"
import { GestureHandlerPackage } from '@react-native-oh-tpl/react-native-gesture-handler/ts';
import {SafeAreaViewPackage} from '@react-native-oh-tpl/react-native-safe-area-context/ts';

export function getRNOHPackages(ctx: RNPackageContext): RNPackage[] {
  return [
    ...createRNOHPackagesAutolinking(ctx),
    new RNOHScreensPackage(ctx), // comment this line out when testing SamplePackage autolinking
    new GestureHandlerPackage(ctx),
    new SafeAreaViewPackage(ctx),
  ]
}