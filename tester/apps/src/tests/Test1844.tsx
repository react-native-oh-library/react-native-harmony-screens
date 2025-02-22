import React, {useState} from 'react';
import {Dimensions, Image, StyleSheet, Text, View} from 'react-native';
import {NavigationContainer, ParamListBase} from '@react-navigation/native';
import {
  createNativeStackNavigator,
  NativeStackNavigationProp,
} from '@react-navigation/native-stack';
import {useHeaderHeight} from '@react-navigation/elements';
import {
  GestureHandlerRootView,
  ScrollView,
  State,
  TapGestureHandler,
} from 'react-native-gesture-handler';
import {FullWindowOverlay} from 'react-native-screens';

const Stack = createNativeStackNavigator();

function HeaderOverlay() {
  const headerHeight = useHeaderHeight();

  return (
    <FullWindowOverlay>
      <View
        style={{
          display: 'flex',
          justifyContent: 'flex-end',
          alignItems: 'center',

          backgroundColor: 'red',
          width: '100%',
          opacity: 0.5,
          height: headerHeight,
        }}>
        <Text>Header height: {headerHeight}</Text>
      </View>
    </FullWindowOverlay>
  );
}

function First({
  navigation,
}: {
  navigation: NativeStackNavigationProp<ParamListBase>;
}) {
  return (
    <ScrollView>
      <HeaderOverlay />
      <Post onPress={() => navigation.navigate('Second')} />
    </ScrollView>
  );
}

function Second() {
  return (
    <ScrollView>
      <Text style={styles.subTitle}>
        Use swipe back gesture to go back (iOS only)
      </Text>
      <Post />
    </ScrollView>
  );
}

export default function App() {
  return (
    <GestureHandlerRootView style={{flex: 1}}>
      <NavigationContainer>
        <Stack.Navigator
          screenOptions={{
            fullScreenGestureEnabled: true,
            animation: 'default',
            animationMatchesGesture: true,
            headerLargeTitle: true,
          }}>
          <Stack.Screen name="First" component={First} />
          <Stack.Screen name="Second" component={Second} />
        </Stack.Navigator>
      </NavigationContainer>
    </GestureHandlerRootView>
  );
}

// components

function Post({onPress}: {onPress?: () => void}) {
  const [width] = useState(Math.round(Dimensions.get('screen').width));

  return (
    <TapGestureHandler
      onHandlerStateChange={e =>
        e.nativeEvent.oldState === State.ACTIVE && onPress?.()
      }>
      <View style={styles.post}>
        <Text style={styles.title}>Post</Text>
        <ScrollView horizontal>{generatePhotos(4, width, 400)}</ScrollView>
        <Text style={styles.caption}>Scroll right for more photos</Text>
      </View>
    </TapGestureHandler>
  );
}

// helpers
function generatePhotos(
  amount: number,
  width: number,
  height: number,
): JSX.Element[] {
  const startFrom = Math.floor(Math.random() * 20) + 10;
  return Array.from({length: amount}, (_, index) => {
    const uri = `https://picsum.photos/id/${
      startFrom + index
    }/${width}/${height}`;
    return <Image style={{width, height}} key={uri} source={{uri}} />;
  });
}

const styles = StyleSheet.create({
  title: {
    fontWeight: 'bold',
    fontSize: 32,
    marginBottom: 8,
    marginLeft: 8,
  },
  subTitle: {
    fontSize: 18,
    marginVertical: 16,
    textAlign: 'center',
  },
  caption: {
    textAlign: 'center',
    marginTop: 4,
  },
  post: {
    borderColor: '#ccc',
    borderTopWidth: 1,
    borderBottomWidth: 1,
    paddingVertical: 10,
    marginBottom: 16,
    backgroundColor: 'white',
  },
});
