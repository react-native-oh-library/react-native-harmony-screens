import type { RNPackageContext, RNOHPackage } from '@rnoh/react-native-openharmony';
import { createRNOHPackages as createRNOHPackagesAutolinking } from "./RNOHPackagesFactory"
import RNOHScreensPackage from "@rnoh/react-native-openharmony-screens"

export function getRNOHPackages(ctx: RNPackageContext): RNOHPackage[] {
  return [
    ...createRNOHPackagesAutolinking(ctx),
    new RNOHScreensPackage(ctx), // comment this line out when testing SamplePackage autolinking
  ]
}