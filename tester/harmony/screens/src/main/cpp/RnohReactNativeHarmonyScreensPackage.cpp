#pragma once
#include "RnohReactNativeHarmonyScreensPackage.h"
#include "RNOH/RNInstanceCAPI.h"
#include <glog/logging.h>

using namespace rnoh;
using namespace facebook;

class RNScreensEventEmitRequestHandler : public EventEmitRequestHandler {
    void handleEvent(EventEmitRequestHandler::Context const &ctx) override {}
};

class RNOHCorePackageComponentInstanceFactoryDelegate : public ComponentInstanceFactoryDelegate {
public:
    using ComponentInstanceFactoryDelegate::ComponentInstanceFactoryDelegate;

    ComponentInstance::Shared create(ComponentInstance::Context ctx) override { return nullptr; }
};


EventEmitRequestHandlers RnohReactNativeHarmonyScreensPackage::createEventEmitRequestHandlers() { return {}; }

ComponentInstanceFactoryDelegate::Shared
RnohReactNativeHarmonyScreensPackage::createComponentInstanceFactoryDelegate() {
    return std::make_shared<RNOHCorePackageComponentInstanceFactoryDelegate>();
}


std::vector<ArkTSMessageHandler::Shared> RnohReactNativeHarmonyScreensPackage::createArkTSMessageHandlers() {
    return {};
}