#pragma once
#include "RNOH/Package.h"

namespace rnoh {
class ScreensPackage : public Package {
public:
    ScreensPackage(Package::Context ctx) : Package(ctx) {}

    EventEmitRequestHandlers createEventEmitRequestHandlers();

    ComponentInstanceFactoryDelegate::Shared createComponentInstanceFactoryDelegate();

    std::vector<ArkTSMessageHandler::Shared> createArkTSMessageHandlers() override;
};
} // namespace rnoh

