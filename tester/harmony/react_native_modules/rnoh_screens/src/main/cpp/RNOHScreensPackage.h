#include "RNOH/Package.h"

namespace rnoh {

class RNOHScreensPackage : public Package {
  public:
    RNOHScreensPackage(Package::Context ctx) : Package(ctx) {}

    std::vector<facebook::react::ComponentDescriptorProvider> createComponentDescriptorProviders() override;

    EventEmitRequestHandlers createEventEmitRequestHandlers() override;
};
} // namespace rnoh