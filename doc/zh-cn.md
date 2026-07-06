> 模板版本：v0.2.2

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


> [!TIP] [Github 地址](https://github.com/react-native-oh-library/react-native-harmony-screens)

## 安装与使用

本库实现依赖 @react-navigation/native 、 @react-navigation/native-stack 、 @react-native-oh-tpl/react-native-safe-area-context 、 @react-native-oh-tpl/react-native-gesture-handler 的原生端代码，如已在工程中引入过该库，则无需再次引入，可跳过本章节步骤，直接使用。

注：若已引入 `@react-native-oh-tpl/native-stack` 库，请务必卸载，否则本库将无法正确指向，导致无法使用。

如未引入请参照 [@react-navigation/native 文档的 Link 章节](/zh-cn/react-navigation-native.md) ，[@react-native-oh-tpl/react-native-gesture-handler 文档的 Link 章节](/zh-cn/react-native-gesture-handler.md) ，[@react-native-oh-tpl/react-native-safe-area-context 文档的 Link 章节](/zh-cn/react-native-safe-area-context.md)进行引入。

请到三方库的 Releases 发布地址查看配套的版本信息：[@react-native-oh-tpl/react-native-screens Releases](https://github.com/react-native-oh-library/react-native-harmony-screens/releases) 。对于未发布到npm的旧版本，请参考[安装指南](/zh-cn/tgz-usage.md)安装tgz包。

进入到工程目录并输入以下命令：

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

下面的代码展示了这个库的基本使用场景：

> [!WARNING] 使用时 import 的库名不变。

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

##  使用 Codegen

本库已经适配了 `Codegen` ，在使用前需要主动执行生成三方库桥接代码，详细请参考[ Codegen 使用文档](https://gitee.com/react-native-oh-library/usage-docs/blob/master/zh-cn/codegen.md)。

## Link


目前HarmonyOS暂不支持 AutoLink，所以 Link 步骤需要手动配置。
首先需要使用 DevEco Studio 打开项目里的HarmonyOS工程 `harmony`

### 1.在工程根目录的 `oh-package.json5` 添加 overrides 字段

```json
{
  ...
  "overrides": {
    "@rnoh/react-native-openharmony" : "file:../node_modules/@rnoh/react-native-harmony/harmony/react_native_openharmony.har"
  }
}
```

### 2.引入原生端代码

目前有两种方法：

1. 通过 har 包引入（在 IDE 完善相关功能后该方法会被遗弃，目前首选此方法）；
2. 直接链接源码。

方法一：通过 har 包引入（推荐）

> [!TIP] har 包位于三方库安装路径的 `harmony` 文件夹下。

打开 `entry/oh-package.json5`，添加以下依赖

```json
"dependencies": {
    "@rnoh/react-native-openharmony": "file:../../node_modules/@rnoh/react-native-harmony/harmony/react_native_openharmony.har",
    "@react-native-oh-tpl/react-native-screens": "file:../../node_modules/@react-native-oh-tpl/react-native-screens/harmony/screens.har"
  }
```

点击右上角的 `sync` 按钮

或者在终端执行：

```bash
cd entry
ohpm install
```

方法二：直接链接源码

> [!TIP] 如需使用直接链接源码，请参考[直接链接源码说明](/zh-cn/link-source-code.md)

### 3.配置 CMakeLists 和引入 Package

打开 `entry/src/main/cpp/CMakeLists.txt`，添加：

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

打开 `entry/src/main/cpp/PackageProvider.cpp`，添加：

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

### 4.在ArkTs侧导入组件

找到 function buildCustomRNComponent()，一般位于 entry/src/main/ets/pages/index.ets 或 entry/src/main/ets/rn/LoadBundle.ets，添加：

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

> [!TIP] 本库使用了混合方案，需要添加组件名。

在entry/src/main/ets/pages/index.ets 或 entry/src/main/ets/rn/LoadBundle.ets 找到常量 arkTsComponentNames 在其数组里添加组件名

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

### 5.在ArkTs侧引入Package

打开 `src/main/ets/RNOHPackagesFactory.ets`，添加：

```diff
  ...
import type { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony';
+ import RnohReactNativeHarmonyScreensPackage from '@react-native-oh-tpl/react-native-screens';

export function createRNOHPackages(ctx: RNPackageContext): RNPackage[] {
  return [
    new SamplePackage(ctx),
+    new RnohReactNativeHarmonyScreensPackage(ctx),
  ];
}

```

### 6.运行

点击右上角的 `sync` 按钮

或者在终端执行：

```bash
cd entry
ohpm install
```

然后编译、运行即可。

## 约束与限制
### 兼容性

要使用此库，需要使用正确的 React-Native 和 RNOH 版本。另外，还需要使用配套的 DevEco Studio 和 手机 ROM。

请到三方库相应的 Releases 发布地址查看 Release 配套的版本信息：[@react-native-oh-tpl/react-native-harmony-screens Releases](https://github.com/react-native-oh-library/react-native-harmony-screens/releases)

## 属性

> [!TIP] "Platform"列表示该属性在原三方库上支持的平台。

> [!TIP] "HarmonyOS Support"列为 yes 表示 HarmonyOS 平台支持该属性；no 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。

| Name                                                      | Description                                                  | Type     | Required | Platform    | HarmonyOS Support |
| --------------------------------------------------------- | ------------------------------------------------------------ | -------- | -------- | ----------- | ----------------- |
| enableScreens                                             | 支持原生及其 React Native View                               | function | No       | iOS Android | Yes               |
| enableFreeze                                              | 对 react-freeze 的支持，使用 ReactSuspense 机制来防止 React 组件树的部分渲染 | function | No       | iOS Android | Yes               |
| createNativeStackNavigator                                | 提供屏幕切换的能力                                                                             | function | No       | iOS Android | NO                |
| NativeStackNavigationProp                                 | 切换页面属性的封装                                                                             | object   | No       | iOS Android | Yes               |
| NativeStackNavigationOptions                              | 导航栏属性设置封装                                                                             | object   | No       | iOS Android | NO                |
| FullWindowOverlay                                         | 一个组件，可以将其子组件放在其他组件之上                                                                  | object   | No       | iOS Android | NO                |
| SearchBarProps                                            | 搜索栏的属性设置封装                                                                            | object   | No       | iOS Android | NO                |
| SearchBarCommands                                         | 搜索栏的操作封装                                                                              | object   | No       | iOS Android | NO                |
| useTransitionProgress                                     | 提供屏幕过渡的动画插值器                                                                          | function | No       | iOS Android | NO                |
| userReanimatedTransitionProgress ReanimatedScreenProvider | 屏幕切换期间调用的帧回调，用于 react-native-reanimated 2.0 及其以上的版本，并使用 ReanimatedScreenProvider 进行封装 | function | No       | iOS Android | NO                |
| userHeaderHeight                                          | 计算静态标题栏的高度，当屏幕方向发生更改，此值会发生更改                                                          | function | No       | iOS Android | NO                |
| userAnimatedHeaderHeight                                  | 动态计算标题栏的高度，此值会随着每个视图布局变化而变化                                                           | function | No       | iOS Android | NO                |
| onAppear                                 | 页面显示         | function | No       | iOS Android |   Yes |
| onDisappear                              | 页面消失         | function | No       | iOS Android |   Yes |
| onWillAppear                             | 页面将显示       | function | No       | iOS Android |   Yes |
| onWillDisappear                          | 页面将消失       | function | No       | iOS Android |   Yes |
| fullScreenSwipeEnabled                   | 全屏滑动         | property | No       | iOS Android |   Yes |
| gestureEnabled                           | 是否开启手势滑动 | property | No       | iOS Android |   Yes |
| statusBarColor                           | 状态栏颜色       | property | No       | iOS Android |   No  |
| screenOrientation                        | 屏幕显示方向     | property | No       | iOS Android |   Yes |
| statusBarStyle                           | 状态栏样式       | property | No       | iOS Android |   Yes |
| statusBarTranslucent                     | 状态栏是否透明化       | property | No       | iOS Android | Yes |
| statusBarHidden			   | 隐藏状态栏       | property | No       | iOS Android |   Yes |
| gestureResponseDistance                  | 手势滑动的有效区域       | property | No       | iOS Android |   Yes |
| stackPresentation                        | 页面类型       | property | No       | iOS Android |   Yes |
| stackAnimation                           | 转场动画类型       | property | No       | iOS Android |   Yes |
| replaceAnimation                         | 进出栈类型       | property | No       | iOS Android |   Yes |
| backgroundColor                          | 标题栏背景色       | property | No       | iOS Android |   Yes |
| hidden                           | 隐藏标题栏       | property | No       | iOS Android |   Yes |
| translucent                      | 标题栏是否透明化       | property | No       | iOS Android |   Yes |
| hideBackButton                   | 隐藏标题栏返回按钮      | property | No       | iOS Android |   Yes |
| backTitle                        | 返回按钮文本内容       | property | No       | iOS Android |   Yes |
| backTitleFontSize                | 返回按钮文本字号大小    | property | No       | iOS Android |   Yes |
| backTitleVisible                 | 返回按钮文本是否显示    | property | No       | iOS Android |   Yes |
| title                            | 标题栏标题       | property | No       | iOS Android |   Yes |
| titleFontSize                    | 标题字号大小        | property | No       | iOS Android |   Yes |
| titleFontWeight                  | 标题字号比重       | property | No       | iOS Android |   Yes |
| titleColor                       | 标题颜色 | property | No       | iOS Android |   Yes |
| type                             | 子标题类型      | property | No       | iOS Android |   Yes |
| onSearchFocus                    | 搜索栏聚焦       | function | No       | iOS Android |   Yes |
| onSearchBlur                     | 搜索栏失去焦点       | function | No       | iOS Android |   Yes |
| onSearchButtonPress              | 搜索       | function | No       | iOS Android |   Yes |
| onCancelButtonPress              | 取消搜索       | function | No       | iOS Android |   Yes |
| onChangeText                     | 搜索栏文本变更       | function | No       | iOS Android |   Yes |
| cancelButtonText                 | 取消按钮文本内容       | property | No       | iOS Android |   Yes |
| barTintColor                     | 搜索背景色       | property | No       | iOS Android |   Yes |
| tintColor                        | 搜索提示文字颜色       | property | No       | iOS Android |   Yes |
| textColor                        | 文字颜色       | property | No       | iOS Android |   Yes |
| inputType                        | 文本输入类型       | property | No       | iOS Android |   Yes |
| onClose                          | 关闭搜索       | function | No       | iOS Android |   Yes |
| onOpen                           | 展示搜索       | function | No       | iOS Android |   Yes |
| headerIconColor                  | 图标颜色       | property | No       | iOS Android |   Yes |
| shouldShowHintSearchIcon         | 是否隐藏搜索图标       | property | No       | iOS Android |   Yes |

## 遗留问题
- [ ] formSheet页面暂使用普通页面，该页面使用的Context.openBindSheet系统方法存在绑定的js页面绑定的位置错乱，造成按钮事件会无法响应。需要系统修正后补充。  [issue#4](https://github.com/react-native-oh-library/react-native-harmony-screens/issues/4)

## 其他

## 开源协议

本项目基于 [The MIT License (MIT)](https://github.com/software-mansion/react-native-screens/blob/main/LICENSE) ，请自由地享受和参与开源。
