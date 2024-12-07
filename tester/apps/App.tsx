import React from 'react';
import {enableFreeze} from 'react-native-screens';
import Example from './Example';
// import * as Test from './src/tests';

enableFreeze(true);

export default function App() {
  return <Example />;
  // return <Test.Test42 />;
}

// import {Button, Text, View} from 'react-native';
// import {NavigationContainer} from '@react-navigation/native';
// import {createNativeStackNavigator} from '@react-navigation/native-stack';

// const Stack = createNativeStackNavigator();

// function HomeScreen({navigation}) {
//   return (
//     <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
//       <Text style={{fontSize: 24, fontWeight: 'bold'}}>Home Screen</Text>
//       <Button
//         title="Go to Details"
//         onPress={() =>
//           navigation.navigate('Details', {
//             itemId: 42,
//             message: 'Hello from Home!',
//           })
//         }
//       />
//     </View>
//   );
// }

// function DetailsScreen({route, navigation}) {
//   // Get the params passed to this screen
//   const {itemId, message} = route.params || {};

//   return (
//     <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
//       <Text style={{fontSize: 24, fontWeight: 'bold'}}>Details Screen</Text>
//       <Text>Item ID: {itemId}</Text>
//       <Text>Message: {message}</Text>
//       <Button title="Go Back" onPress={() => navigation.goBack()} />
//     </View>
//   );
// }

// export default function App() {
//   return (
//     <NavigationContainer>
//       <Stack.Navigator initialRouteName="Home">
//         {/* First screen in the stack */}
//         <Stack.Screen
//           name="Home"
//           component={HomeScreen}
//           options={{
//             title: 'Home Screen', // Title shown in the header
//           }}
//         />
//         {/* Second screen in the stack */}
//         <Stack.Screen
//           name="Details"
//           component={DetailsScreen}
//           options={{
//             title: 'Details Screen',
//           }}
//         />
//       </Stack.Navigator>
//     </NavigationContainer>
//   );
// }
