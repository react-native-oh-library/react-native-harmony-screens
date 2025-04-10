import React, {useState, useLayoutEffect, useEffect} from 'react';
import {StyleSheet, ScrollView, Text, Platform} from 'react-native';
import {
  createNativeStackNavigator,
  NativeStackNavigationProp,
} from '@react-navigation/native-stack';

import {
  SettingsInput,
  SettingsPicker,
  SettingsSwitch,
  Square,
  Button,
  ToastProvider,
  useToast,
} from '../shared';
import {BlurEffectTypes} from 'react-native-screens';

type StackParamList = {
  Main: undefined;
  Settings: undefined;
};

interface MainScreenProps {
  navigation: NativeStackNavigationProp<StackParamList, 'Main'>;
}

const MainScreen = ({navigation}: MainScreenProps): React.JSX.Element => {
  useEffect(() => {
    navigation.navigate('Settings');
  }, []);

  return (
    <ScrollView>
      <Button
        onPress={() => navigation.navigate('Settings')}
        title="Go to next screen"
      />
      <Button onPress={() => navigation.pop()} title="🔙 Back to Examples" />
    </ScrollView>
  );
};

type HeaderItemPosition = 'left' | 'center' | 'right';
type HeaderTitleAlignment = 'left' | 'center';
type FontWeight =  'normal' | 'bold' | '100' | '200' | '300' | '400' | '500' | '600' | '700' | '800' | '900';

interface SettingsScreenProps {
  navigation: NativeStackNavigationProp<StackParamList, 'Settings'>;
}

const SettingsScreen = ({
  navigation,
}: SettingsScreenProps): React.JSX.Element => {
  const toast = useToast();

  const [headerTitle, setHeaderTitle] = useState('Settings');
  const [backButtonVisible, setBackButtonVisible] = useState(true);
  const [headerShown, setHeaderShown] = useState(true);
  const [headerTitleAlign, setHeaderTitleAlign] =
    useState<HeaderTitleAlignment>('left');
  const [headerLargeTitle, setHeaderLargeTitle] = useState(true);
  const [headerItem, setHeaderItem] = useState<HeaderItemPosition>('right');
  const [headerBackTitle, setHeaderBackTitle] = useState('Back');
  const [headerBackTitleVisible, setHeaderBackTitleVisible] = useState(true);
  const [headerShadowVisible, setHeaderShadowVisible] = useState(false);
  const [headerTransparent, setHeaderTransparent] = useState(false);
  const [headerBlurEffect, setHeaderBlurEffect] =
    useState<BlurEffectTypes>('extraLight');

  const [backgroundColor, setBackgroundColor] = useState('#0000ff');  
  const [color, setColor] = useState('#FF69B4');
  const [fontSize, setFontSize] = useState(18);
  const [fontWeight, setFontWeight] = useState<FontWeight>('normal'); 

  const square = (props: {tintColor?: string}) => (
    <Square {...props} color="green" size={20} />
  );

  useLayoutEffect(() => {
    navigation.setOptions({
      headerBackVisible: backButtonVisible,
      headerBackTitleVisible: backButtonVisible|| headerBackTitleVisible, // iOS
      headerLargeTitle, // iOS
      headerBackTitle, // iOS
      headerShown,
      headerTitleAlign, // Android
      headerRight: headerItem === 'right' ? square : undefined,
      headerTitle: headerItem === 'center' ? square : headerTitle,
      headerLeft: headerItem === 'left' ? square : undefined,
      headerShadowVisible,
      headerTransparent,
      headerBlurEffect,
      headerStyle: {
        backgroundColor,
      },
      headerTitleStyle:{
        color,
        fontSize,
        fontWeight, 
      },
      headerBackTitleStyle: {
        fontSize
      }
    });
  }, [
    navigation,
    headerTitle,
    backButtonVisible,
    headerLargeTitle,
    headerBackTitle,
    headerBackTitleVisible,
    headerItem,
    headerTitleAlign,
    headerShown,
    headerShadowVisible,
    headerTransparent,
    headerBlurEffect,
    backgroundColor,
    color,
    fontSize,
    fontWeight,
  ]);

  return (
    <ScrollView
      contentInsetAdjustmentBehavior="automatic"
      style={styles.container}>
      <SettingsInput
        label="Header title"
        value={headerTitle}
        onValueChange={setHeaderTitle}
      />
      <SettingsSwitch
        label="Back button visible"
        value={backButtonVisible}
        onValueChange={setBackButtonVisible}
      />
      <SettingsSwitch
        label="Header shown"
        value={headerShown}
        onValueChange={setHeaderShown}
      />
      <SettingsPicker<HeaderTitleAlignment>
        label="Header title align"
        value={headerTitleAlign}
        onValueChange={setHeaderTitleAlign}
        items={['left', 'center']}
      />
      <SettingsSwitch
        label="Header shadow visible"
        value={headerShadowVisible}
        onValueChange={setHeaderShadowVisible}
      />
      <SettingsSwitch
        label="Header transparent"
        value={headerTransparent}
        onValueChange={setHeaderTransparent}
      />
      <SettingsPicker<HeaderItemPosition>
        label="Header item"
        value={headerItem}
        onValueChange={item => {
          if (item === 'left' && backButtonVisible) {
            // to make header's item ideally on the left side,
            // we need to hide the back button.
            // toast.push({
            //   message: 'Hiding back button...',
            //   backgroundColor: 'orange',
            // });
            setBackButtonVisible(false);
            setHeaderBackTitleVisible(false)
          }
          if (
            item === 'center' &&
            // Platform.OS === 'android' && // todo edit
            Platform.OS !== 'ios' &&
            headerTitleAlign !== 'center'
          ) {
            // on Android, we can't have a header item in the center
            // and a title at the same time
            // toast.push({
            //   message: 'Changing title alignment to center...',
            //   backgroundColor: 'orange',
            // });
            setHeaderTitleAlign('center');
          }
          setHeaderItem(item);
        }}
        items={['left', 'center', 'right']}
      />
      <SettingsInput
        label="Header backgroundColor"
        value={backgroundColor}
        onValueChange={setBackgroundColor}
      />
      <SettingsInput
        label="Header titleColor"
        value={color}
        onValueChange={setColor}
      />
      <Button
        onPress={() => {
          setFontSize(12)
        }}
        title="set titleFontSize 12"
        testID="Header-titleFontSize"
      />      
      <SettingsPicker<FontWeight>
        label="Header titleFontWeight"
        value={fontWeight}
        items={[
         'normal',
         'bold',
         '100',
         '200',
        ]}
        onValueChange={setFontWeight}
      /> 
      <Text style={styles.heading}>iOS only</Text>
      <SettingsSwitch
        label="Header large title"
        value={headerLargeTitle}
        onValueChange={setHeaderLargeTitle}
      />
      <SettingsInput
        label="Header back title"
        value={headerBackTitle}
        onValueChange={setHeaderBackTitle}
      />
      <SettingsSwitch
        label="Header back title visible:"
        value={headerBackTitleVisible}
        onValueChange={setHeaderBackTitleVisible}
      />
      <SettingsPicker<BlurEffectTypes>
        label="Header blur effect"
        value={headerBlurEffect}
        items={[
          'extraLight',
          'light',
          'dark',
          'regular',
          'prominent',
          'systemUltraThinMaterial',
          'systemThinMaterial',
          'systemMaterial',
          'systemThickMaterial',
          'systemChromeMaterial',
          'systemUltraThinMaterialLight',
          'systemThinMaterialLight',
          'systemMaterialLight',
          'systemThickMaterialLight',
          'systemChromeMaterialLight',
          'systemUltraThinMaterialDark',
          'systemThinMaterialDark',
          'systemMaterialDark',
          'systemThickMaterialDark',
          'systemChromeMaterialDark',
        ]}
        onValueChange={setHeaderBlurEffect}
      />
      <Button title="Go back" onPress={() => navigation.goBack()} />
    </ScrollView>
  );
};

const Stack = createNativeStackNavigator<StackParamList>();

const App = (): React.JSX.Element => (
  <ToastProvider>
    <Stack.Navigator
      screenOptions={{
        headerBackVisible: false,
      }}>
      <Stack.Screen
        name="Main"
        options={{
          title: 'Header Options',
        }}
        component={MainScreen}
      />
      <Stack.Screen
        name="Settings"
        component={SettingsScreen}
        options={{
          headerTintColor: '#FF69B4',
        }}
      />      
    </Stack.Navigator>
  </ToastProvider>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 10,
  },
  heading: {
    marginLeft: 10,
    fontWeight: 'bold',
    fontSize: 16,
  },
});

export default App;
