> Template version: v0.2.2

<p align="center">
  <h1 align="center"> <code>@react-native-oh-tpl/react-native-screens</code> </h1>
</p>
<p align="center">
    <a href="https://github.com/software-mansion/react-native-screens">
        <img src="https://img.shields.io/badge/platforms-iOS%20|%20Android%20|%20tvOS%20|%20Windows%20|%20Web%20|%20harmony%20-lightgrey.svg" alt="Supported platforms" />
    </a>
    <a href="https://github.com/software-mansion/react-native-screens/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License" />
    </a>
</p>


> [!TIP] [GitHub address](https://github.com/react-native-oh-library/react-native-harmony-screens)

## Installation and Usage

The implementation of this library depends on the native  code from @react-native-oh-tpl/native and @react-navigation/native-stack and @react-native-oh-tpl/react-native-safe-area-context and @react-native-oh-tpl/react-native-gesture-handler. If this library is included into your application, there is no need to include it again; you can skip the steps in this section and use it directly.

Note: If the `@react-native-oh-tpl/native-stack` library has been introduced, please uninstall it. Otherwise, this library will fail to be referenced and cannot be used.

If it is not included, follow the guide provided in [@react-native-oh-tpl/native](/en/react-navigation-native.md) and [@react-native-oh-tpl/react-native-safe-area-context](/en/react-native-safe-area-context.md) and [@react-native-oh-tpl/react-native-gesture-handler](/en/react-native-gesture-handler.md) to add it to your project.

Please visit the Releases page of the third-party library to check the corresponding version information: [@react-native-oh-tpl/react-native-screens Releases](https://github.com/react-native-oh-library/react-native-harmony-screens/releases). For older versions that have not been published to npm, please refer to the [Installation Guide](/zh-cn/tgz-usage.md) to install the tgz package.

Go to the project directory and execute the following instruction:
#### **npm**

```bash
npm install @react-native-oh-tpl/react-native-screens
npm install @react-navigation/native-stack@6.9.13
```

#### **yarn**

```bash
yarn install @react-native-oh-tpl/react-native-screens
yarn install @react-navigation/native-stack@6.9.13
```

The following code shows the basic use scenario of the repository:

> [!WARNING] The name of the imported repository remains unchanged.

```js
import * as React from 'react';
import { Button, View } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { enableScreens } from "react-native-screens";
enableScreens(true);

function HomeScreen({ navigation }) {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Button
        title="Go to Profile"
        onPress={() => navigation.navigate('Profile')}
      />
    </View>
  );
}

function ProfileScreen({ navigation }) {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Button
        title="Go to Notifications"
        onPress={() => navigation.navigate('Notifications')}
      />
      <Button title="Go back" onPress={() => navigation.goBack()} />
    </View>
  );
}

function NotificationsScreen({ navigation }) {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Button
        title="Go to Settings"
        onPress={() => navigation.navigate('Settings')}
      />
      <Button title="Go back" onPress={() => navigation.goBack()} />
    </View>
  );
}

function SettingsScreen({ navigation }) {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Button title="Go back" onPress={() => navigation.goBack()} />
    </View>
  );
}

const Stack = createNativeStackNavigator();

function MyStack() {
  return (
    <Stack.Navigator
      initialRouteName="Home"
      screenOptions={{
        headerTintColor: '#999999',
        headerStyle: { backgroundColor: '#ff00ff' },
      }}
    >
      <Stack.Screen name="Home" component={HomeScreen} />
      <Stack.Screen name="Notifications" component={NotificationsScreen} />
      <Stack.Screen name="Profile" component={ProfileScreen} />
      <Stack.Screen name="Settings" component={SettingsScreen} />
    </Stack.Navigator>
  );
}

export default function App() {
  return (
    <NavigationContainer>
      <MyStack />
    </NavigationContainer>
  );
}

```


## Use Codegen

If this repository has been adapted to `Codegen`, generate the bridge code of the third-party library by using the `Codegen`. For details, see [Codegen Usage Guide](https://gitee.com/react-native-oh-library/usage-docs/blob/master/en/codegen.md).

## Link

Currently, HarmonyOS does not support AutoLink. Therefore, you need to manually configure the linking.
Open the `harmony` directory of the HarmonyOS project in DevEco Studio.

### 1. Adding the overrides Field to oh-package.json5 File in the Root Directory of the Project

```json
{
  ...
  "overrides": {
    "@rnoh/react-native-openharmony" : "file:../node_modules/@rnoh/react-native-harmony/harmony/react_native_openharmony.har"
  }
}
```
### 2. Introducing Native Code

Currently, two methods are available:


Method 1 (recommended): Use the HAR file.

> [!TIP] The HAR file is stored in the `harmony` directory in the installation path of the third-party library.

Open `entry/oh-package.json5` file and add the following dependencies:

```json
"dependencies": {
    "@rnoh/react-native-openharmony": "file:../../node_modules/@rnoh/react-native-harmony/harmony/react_native_openharmony.har",
    "@react-native-oh-tpl/react-native-screens": "file:../../node_modules/@react-native-oh-tpl/react-native-screens/harmony/screens.har"
  }
```

Click the `sync` button in the upper right corner.

Alternatively, run the following instruction on the terminal:

```bash
cd entry
ohpm install
```

Method 2: Directly link to the source code.

> [!TIP] For details, see [Directly Linking Source Code](/en/link-source-code.md).

### 3. Configuring CMakeLists and Introducing Package

Open `entry/src/main/cpp/CMakeLists.txt` and add the following code:

```diff
project(rnapp)
cmake_minimum_required(VERSION 3.4.1)
set(CMAKE_SKIP_BUILD_RPATH TRUE)
set(RNOH_APP_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(NODE_MODULES "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../node_modules")
set(RNOH_CPP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules/@rnoh/react-native-openharmony/src/main/cpp")
+ set(OH_MODULES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules")
set(RNOH_GENERATED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/generated")
set(LOG_VERBOSITY_LEVEL 1)
set(CMAKE_ASM_FLAGS "-Wno-error=unused-command-line-argument -Qunused-arguments")
set(CMAKE_CXX_FLAGS "-fstack-protector-strong -Wl,-z,relro,-z,now,-z,noexecstack -s -fPIE -pie")
set(WITH_HITRACE_SYSTRACE 1) # for other CMakeLists.txt files to use
add_compile_definitions(WITH_HITRACE_SYSTRACE)

add_subdirectory("${RNOH_CPP_DIR}" ./rn)

# RNOH_BEGIN: manual_package_linking_1
add_subdirectory("../../../../sample_package/src/main/cpp" ./sample-package)
+ add_subdirectory("${OH_MODULES_DIR}/@react-native-oh-tpl/react-native-screens/src/main/cpp" ./rnoh_screens)
# RNOH_END: manual_package_linking_1

file(GLOB GENERATED_CPP_FILES "./generated/*.cpp")

add_library(rnoh_app SHARED
    ${GENERATED_CPP_FILES}
    "./PackageProvider.cpp"
    "${RNOH_CPP_DIR}/RNOHAppNapiBridge.cpp"
)
target_link_libraries(rnoh_app PUBLIC rnoh)

# RNOH_BEGIN: manual_package_linking_2
target_link_libraries(rnoh_app PUBLIC rnoh_sample_package)
+ target_link_libraries(rnoh_app PUBLIC rnoh_screens)
# RNOH_END: manual_package_linking_2
```

Open `entry/src/main/cpp/PackageProvider.cpp`, add:

```diff
#include "RNOH/PackageProvider.h"
#include "generated/RNOHGeneratedPackage.h"
+ #include "RnohReactNativeHarmonyScreensPackage.h"

using namespace rnoh;

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    return {
        std::make_shared<RNOHGeneratedPackage>(ctx),
        std::make_shared<SamplePackage>(ctx),
+        std::make_shared<rnoh::RnohReactNativeHarmonyScreensPackage>(ctx),
    };
}
```

### 4. Introducing Component to ArkTS

Find `function buildCustomRNComponent()`, which is usually located in `entry/src/main/ets/pages/index.ets` or `entry/src/main/ets/rn/LoadBundle.ets`, and add the following code:

```diff
  ...
+ import { componentBuilder } from "@react-native-oh-tpl/react-native-screens"

@Builder
export function buildCustomRNComponent(ctx: ComponentBuilderContext) {
  ...
  Stack() {
+    componentBuilder(ctx)
  }
  ...
}
...
```

> [!TIP] If the repository uses a mixed solution, the component name needs to be added. 

Find the constant `arkTsComponentNames` in `entry/src/main/ets/pages/index.ets` or `entry/src/main/ets/rn/LoadBundle.ets` and add the component name to the array.

```diff
const arkTsComponentNames: Array<string> = [
+ "RNSScreen", 
+ "RNSFullWindowOverlay", 
+ "RNSModalScreen", 
+ "RNSScreenContainer", 
+ "RNSScreenNavigationContainer", 
+ "RNSScreenStack", 
+ "RNSScreenStackHeaderSubview", 
+ "RNSSearchBar", 
+ "RNSScreenStackHeaderConfig", 
+ "RNSScreenStackHeaderSubview"
];
```

### 5. Introducing Package to ArkTS

Open `src/main/ets/RNOHPackagesFactory.ets`, add:

```diff
import type { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony';
+ import RnohReactNativeHarmonyScreensPackage from '@react-native-oh-tpl/react-native-screens';

export function createRNOHPackages(ctx: RNPackageContext): RNPackage[] {
  return [
    new SamplePackage(ctx),
+    new RnohReactNativeHarmonyScreensPackage(ctx),
  ];
}

```

### 6. Running

Click the `sync` button in the upper right corner.

Alternatively, run the following instruction on the terminal:

```bash
cd entry
ohpm install
```

Then build and run the code.

## Constraints

### Compatibility

To use this repository, you need to use the correct React-Native and RNOH versions. In addition, you need to use DevEco Studio and the ROM on your phone.

Check the release version information in the release address of the third-party library: [@react-native-oh-tpl/react-native-screens Releases](https://github.com/react-native-oh-library/react-native-harmony-screens/releases)

## Properties

> [!TIP] The **Platform** column indicates the platform where the properties are supported in the original third-party library.

> [!TIP] If the value of **HarmonyOS Support** is **yes**, it means that the HarmonyOS platform supports this property; **no** means the opposite; **partially** means some capabilities of this property are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

| Name                                                      | Description                                                  | Type     | Required | Platform    | HarmonyOS Support |
| --------------------------------------------------------- | ------------------------------------------------------------ | -------- | -------- | ----------- | ----------------- |
| enableScreens                                             | Support native and its React Native View                               | function | No       | iOS Android | Yes               |
| enableFreeze                                              | Support for react-freeze, using ReactSuspende mechanism to prevent partial rendering of React component tree  | function | No       | iOS Android | Yes               |
| createNativeStackNavigator                                | Provides screen switching capabilities.                                          | function | No       | iOS Android | NO                |
| NativeStackNavigationProp                                 | Encapsulates the property of page switching.                                          | object   | No       | iOS Android | Yes               |
| NativeStackNavigationOptions                              | Encapsulates the property settings of the navigation bar.                                          | object   | No       | iOS Android | NO                |
| FullWindowOverlay                                         | A component that allows placing its child components above other components.                    | object   | No       | iOS Android | NO                |
| SearchBarProps                                            | Encapsulates the property settings of the search bar.                                        | object   | No       | iOS Android | NO                |
| SearchBarCommands                                         | Encapsulates the operations of the search bar.                                            | object   | No       | iOS Android | NO                |
| useTransitionProgress                                     | Provides an animation interpolator for screen transitions.                                    | function | No       | iOS Android | NO                |
| userReanimatedTransitionProgress ReanimatedScreenProvider | Frame callback called during screen transitions, used for react-native-reanimated 2.0 and above, encapsulated with **ReanimatedScreenProvider**.| function | No       | iOS Android | NO                |
| userHeaderHeight                                          | Calculates the height of the static header bar. This value changes when the screen orientation changes.    | function | No       | iOS Android | NO                |
| userAnimatedHeaderHeight                                  | Dynamically calculates the height of the header bar. This value changes with each view layout change.      | function | No       | iOS Android | NO                |
| onAppear                                 | A callback that gets called when the current screen appears        | function | No       | iOS Android |   Yes |
| onDisappear                              | A callback that gets called when the current screen disappears.    | function | No       | iOS Android |   Yes |
| onWillAppear                             | A callback that gets called when the current screen will appear       | function | No       | iOS Android |   Yes |
| onWillDisappear                          | A callback that gets called when the current screen will disappear       | function | No       | iOS Android |   Yes |
| fullScreenSwipeEnabled                   | Boolean indicating whether the swipe gesture should work on whole screen         | property | No       | iOS Android |   Yes |
| gestureEnabled                           |  Whether you can use gestures to dismiss this screen | property | No       | iOS Android |   Yes |
| statusBarColor                           | Sets the status bar color       | property | No       | iOS Android |   No  |
| screenOrientation                        | In which orientation should the screen appear     | property | No       | iOS Android |   Yes |
| statusBarStyle                           | Sets the status bar color       | property | No       | iOS Android |   Yes |
| statusBarTranslucent                     | Sets the translucency of the status bar       | property | No       | iOS Android | Yes |
| statusBarHidden			   | Whether the status bar should be hidden on this screen       | property | No       | iOS Android |   Yes |
| gestureResponseDistance                  |  Use it to restrict the distance from the edges of screen in which the gesture should be recognized      | property | No       | iOS Android |   Yes |
| stackPresentation                        | how should the screen be presented       | property | No       | iOS Android |   Yes |
| stackAnimation                           | ow the screen should appear/disappear when pushed or popped at the top of the stack       | property | No       | iOS Android |   Yes |
| replaceAnimation                         | How should the screen replacing another screen animate       | property | No       | iOS Android |   Yes |
| backgroundColor                          | Controls the color of the navigation header       | property | No       | iOS Android |   Yes |
| hidden                           | When set to true the header will be hidden while the parent Screen is on the top of the stack       | property | No       | iOS Android |   Yes |
| translucent                      | Boolean indicating whether the navigation bar is translucent       | property | No       | iOS Android |   Yes |
| hideBackButton                   | Boolean indicating whether to hide the back button in header      | property | No       | iOS Android |   Yes |
| backTitle                        | Title to display in the back button.       | property | No       | iOS Android |   Yes |
| backTitleFontSize                | Allows for customizing font size to be used for back button title    | property | No       | iOS Android |   Yes |
| backTitleVisible                 |  Whether the back button title should be visible or nots    | property | No       | iOS Android |   Yes |
| title                            | String that can be displayed in the header as a fallback for `headerTitle`       | property | No       | iOS Android |   Yes |
| titleFontSize                    | Customize the size of the font to be used for the title.        | property | No       | iOS Android |   Yes |
| titleFontWeight                  | Customize the weight of the font to be used for the title.       | property | No       | iOS Android |   Yes |
| titleColor                       | Allows for setting text color of the title | property | No       | iOS Android |   Yes |
| type                             | Subtitle type      | property | No       | iOS Android |   Yes |
| onSearchFocus                    | Search bar focus       | function | No       | iOS Android |   Yes |
| onSearchBlur                     | Search bar loses focus       | function | No       | iOS Android |   Yes |
| onSearchButtonPress              | A callback that gets called when the search button is pressed       | function | No       | iOS Android |   Yes |
| onCancelButtonPress              | A callback that gets called when the cancel button is pressed       | function | No       | iOS Android |   Yes |
| onChangeText                     | A callback that gets called when the text changes       | function | No       | iOS Android |   Yes |
| cancelButtonText                 | The text to be used instead of default `Cancel` button text       | property | No       | iOS Android |   Yes |
| barTintColor                     | The search field background color       | property | No       | iOS Android |   Yes |
| tintColor                        | The color for the cursor caret and cancel button text       | property | No       | iOS Android |   Yes |
| textColor                        | text color       | property | No       | iOS Android |   Yes |
| inputType                        | Sets type of the input. Defaults to `text`.       | property | No       | iOS Android |   Yes |
| onClose                          | A callback that gets called when search bar is closed       | function | No       | iOS Android |   Yes |
| onOpen                           | A callback that gets called when search bar is opened       | function | No       | iOS Android |   Yes |
| headerIconColor                  | The search and close icon color shown in the header       | property | No       | iOS Android |   Yes |
| shouldShowHintSearchIcon         | Show the search hint icon when search bar is focused       | property | No       | iOS Android |   Yes |

## Known Issues
- [ ] The formSheet page is currently using a regular page, and the Context.openBindSheet system method used on this page has a misalignment of the binding position of the JS page, resulting in unresponsive button events. Need to be supplemented after system correction.  [issue#4](https://github.com/react-native-oh-library/react-native-harmony-screens/issues/4)

## Others

## License

This project is licensed under [The MIT License (MIT)](https://github.com/software-mansion/react-native-screens/blob/main/LICENSE).
