#pragma once
#include "RNOH/Package.h"

namespace rnoh {
class RnohReactNativeHarmonyScreensPackage : public Package {
public:
    RnohReactNativeHarmonyScreensPackage(Package::Context ctx) : Package(ctx) {}

    EventEmitRequestHandlers createEventEmitRequestHandlers();

    ComponentInstanceFactoryDelegate::Shared createComponentInstanceFactoryDelegate();

    std::vector<ArkTSMessageHandler::Shared> createArkTSMessageHandlers() override;
};
} // namespace rnoh
