import React, { useLayoutEffect, useState } from 'react';
import { View, ScrollView, StyleSheet, Text } from 'react-native';
import {
  createNativeStackNavigator,
  NativeStackNavigationProp,
  NativeStackNavigationOptions,
} from '@react-navigation/native-stack';
import { SettingsPicker, SettingsSwitch, Button } from '../shared';

type StackParamList = {
  First: undefined;
  Second: undefined;
  Modal: undefined;
};

type StatusBarStyle = Exclude<
  NativeStackNavigationOptions['statusBarStyle'],
  undefined
>;

type StatusBarAnimation = Exclude<
  NativeStackNavigationOptions['statusBarAnimation'],
  undefined
>;

interface FirstScreenProps {
  navigation: NativeStackNavigationProp<StackParamList, 'First'>;
}

const FirstScreen = ({ navigation }: FirstScreenProps): React.JSX.Element => {
  const [statusBarStyle, setStatusBarStyle] = useState<StatusBarStyle>('auto');
  const [statusBarHidden, setStatusBarHidden] = useState(false);
  const [statusBarAnimation, setStatusBarAnimation] =
    useState<StatusBarAnimation>('fade');
  const [statusBarTranslucent, setStatusBarTranslucent] = useState(true);
  const [statusBarBackgroundColor, setStatusBarBackgroundColor] =
    useState('#d3d3d3'); // gray
  const [statusBarColor, setStatusBarColor] =
    useState('#333333');

  useLayoutEffect(() => {
    navigation.setOptions({
      statusBarStyle,
      statusBarHidden,
      statusBarAnimation,
      statusBarTranslucent,
      statusBarBackgroundColor,
      statusBarColor,
    });
  }, [
    navigation,
    statusBarStyle,
    statusBarHidden,
    statusBarAnimation,
    statusBarTranslucent,
    statusBarBackgroundColor,
    statusBarColor,
  ]);

  return (
    <ScrollView style={styles.container}>
      <SettingsPicker<StatusBarStyle>
        label="Status bar style"
        value={statusBarStyle}
        onValueChange={setStatusBarStyle}
        items={['auto', 'inverted', 'light', 'dark']}
      />
      <SettingsSwitch
        label="Status bar hidden"
        value={statusBarHidden}
        onValueChange={setStatusBarHidden}
      />
      <SettingsPicker<StatusBarAnimation>
        label="Status bar animation"
        value={statusBarAnimation}
        onValueChange={setStatusBarAnimation}
        items={['fade', 'none', 'slide']}
      />
      <Text style={styles.heading}>Android only</Text>
      <SettingsSwitch
        label="Status bar translucent"
        value={statusBarTranslucent}
        onValueChange={setStatusBarTranslucent}
      />
      <SettingsPicker<string>
        label="Status bar color"
        value={statusBarColor}
        onValueChange={setStatusBarColor}
        items={['#ff0000', '#00ff00', '#0000ff', '#333333']}
      />
      {/* items={['red', 'green', 'blue', 'gray']} */}
      <Button
        title="Go to second screen"
        onPress={() => navigation.navigate('Second')}
      />
      <Button title="Open modal" onPress={() => navigation.navigate('Modal')} />
      <Button onPress={() => navigation.pop()} title="🔙 Back to Examples" />
    </ScrollView>
  );
};

interface SecondScreenProps {
  navigation: NativeStackNavigationProp<StackParamList, 'Second'>;
}

const SecondScreen = ({ navigation }: SecondScreenProps): React.JSX.Element => (
  <View style={styles.container}>
    <Button title="Go back" onPress={() => navigation.goBack()} />
  </View>
);

const Stack = createNativeStackNavigator<StackParamList>();

const App = (): React.JSX.Element => (
  <Stack.Navigator
    screenOptions={{
      headerStyle: {
        backgroundColor: '#d3d3d3',
      },
      headerTitleStyle: {
        color: '#ffffff',
      },
      headerBackVisible: false,
    }}>
      {/* backgroundColor: 'gray', */}
      
    <Stack.Screen
      name="First"
      component={FirstScreen}
      options={{
        title: 'Status bar',
      }}
    />
    <Stack.Screen name="Second" component={SecondScreen} />
    <Stack.Screen
      name="Modal"
      component={SecondScreen}
      options={{ presentation: 'modal' }}
    />
  </Stack.Navigator>
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
