#include "RNOH/PackageProvider.h"
#include "generated/RNOHGeneratedPackage.h"
// #include "ScreensPackage.h"
#include "RNOHPackagesFactory.h"

using namespace rnoh;

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    auto packages = createRNOHPackages(ctx); // <= autolinking
    packages.push_back(std::make_shared<RNOHGeneratedPackage>(ctx));
//     packages.push_back(std::make_shared<ScreensPackage>(ctx));
    return packages;
}
