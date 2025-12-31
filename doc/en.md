> Template version: v0.2.2

<p align="center">
  <h1 align="center"> <code>react-native-screens</code> </h1>
</p>
<p align="center">
    <a href="https://github.com/software-mansion/react-native-screens">
        <img src="https://img.shields.io/badge/platforms-iOS%20|%20Android%20|%20tvOS%20|%20Windows%20|%20Web%20|%20harmony%20-lightgrey.svg" alt="Supported platforms" />
    </a>
    <a href="https://github.com/software-mansion/react-native-screens/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License" />
    </a>
</p>

> [!TIP] [GitHub address](https://github.com/software-mansion/react-native-screens/tree/3.29.0)

## Installation and Usage

Go to the project directory and execute the following instruction:

<!-- tabs:start -->

#### **npm**

```bash
npm install @react-navigation/native
npm install @react-native-oh-tpl/stack
npm install @react-native-oh-tpl/react-native-safe-area-context
npm install react-native-screens@3.29.0
```

#### **yarn**

```bash
yarn add @react-navigation/native
yarn add @react-native-oh-tpl/stack
yarn add @react-native-oh-tpl/react-native-safe-area-context
yarn add react-native-screens@3.29.0
```

<!-- tabs:end -->

The following code shows the basic use scenario of the repository:

> [!WARNING] The name of the imported repository remains unchanged.

```js
import React from 'react';
import {ScrollView, Button, View, Text} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';
import { enableScreens } from "react-native-screens";

enableScreens(false);
function Home({navigation}) {
    return (
        <ScrollView
            style={{backgroundColor: 'yellow'}}
            contentInsetAdjustmentBehavior="automatic">
            <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
                <Text>Home Screen</Text>
            </View>
            <Button title="To Detail" onPress={() => navigation.push('Detail')} />
        </ScrollView>
    );
}

function Detail({navigation}) {
    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <Text>Details Screen</Text>
            <Button title="To Home" onPress={() => navigation.goBack()} />
        </View>
    );
}

const Stack = createStackNavigator();

function NativeNavigation() {
    return (
        <NavigationContainer>
            <Stack.Navigator>
                <Stack.Screen
                    name="Home"
                    component={Home}
                    options={{title: 'Home的title'}}
                />
                <Stack.Screen
                    name="Detail"
                    component={Detail}
                    options={{title: 'Detail的title'}}
                />
            </Stack.Navigator>
        </NavigationContainer>
    );
}

export default function RNScreenTest() {
    return <NativeNavigation />;
}

```

#### 禁用 `react-native-screens`

Since ArkUI does not provide CAPIs, the container components need to be CAPI-enabled. Therefore, this library does not implement HarmonyOS native functionality. As a result, **react-native-screens** disables the use of HarmonyOS native screens and uses React Native views instead. Please add the following code to your entry file. For example:`App.js`):

```js
import { enableScreens } from "react-native-screens";

enableScreens(false);
```

You can also disable the native screen in each navigator using [detachInactiveScreens](https://reactnavigation.org/docs/stack-navigator#detachinactivescreens).

## Link

The HarmonyOS implementation of this library depends on the native code from @react-native-oh-tpl/stack and @react-native-oh-tpl/react-native-safe-area-context. If this library is included into your HarmonyOS application, there is no need to include it again; you can skip the steps in this section and use it directly.

If it is not included, follow the guide provided in [@react-native-oh-tpl/stack](/en/react-navigation-stack.md) and [@react-native-oh-tpl/react-native-safe-area-context](/en/react-native-safe-area-context.md) to add it to your project.

## Constraints

### Compatibility

This document is verified based on the following versions:

1.RNOH:0.72.29; SDK:HarmonyOS-NEXT-DB6 5.0.0.61; IDE:DevEco Studio 5.0.3.706; ROM:3.0.0.60;

## Properties

> [!TIP] The **Platform** column indicates the platform where the properties are supported in the original third-party library.

> [!TIP] If the value of **HarmonyOS Support** is **yes**, it means that the HarmonyOS platform supports this property; **no** means the opposite; **partially** means some capabilities of this property are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

| Name                                                      | Description                                                                           | Type     | Required | Platform    | HarmonyOS Support |
|-----------------------------------------------------------|---------------------------------------------------------------------------------------|----------|----------|-------------|-------------------|
| enableScreens                                             | Supports both native and React Native View. View                                                              | function | No       | iOS Android | Yes               |
| enableFreeze                                              | Supports **react-freeze** and uses **ReactSuspense** to prevent partial rendering of the React component tree.| function | No       | iOS Android | Yes               |
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

- [ ] ArkUI does not provide CAPIs, and the container components need to be CAPI-enabled. Therefore, this library does not implement native HarmonyOS adaptation. HarmonyOS only supports a subset of properties.

## Others

## License

This project is licensed under [The MIT License (MIT)](https://github.com/software-mansion/react-native-screens/blob/main/LICENSE).
