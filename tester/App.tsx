/* eslint-disable react/no-unstable-nested-components */
/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import {ScrollView, StyleSheet, TouchableOpacity, View} from 'react-native';
import {Screen} from 'react-native-screens';
import {Tester, TestSuite, TestCase} from '@rnoh/testerino';

enum ActivityState {
  DETACH = 0,
  IN_TRANSITION = 1,
  ATTACHED = 2,
}

function App({}): JSX.Element {
  return (
    <ScrollView style={styles.container}>
      <Tester>
        <TestSuite name="Screen">
          <TestSuite name="activityState">
            <TestCase
              itShould="show rectangle on gray background and be clickable (ATTACHED)"
              initialState={false}
              arrange={({setState}) => {
                return (
                  <Screen
                    enabled={false}
                    style={{backgroundColor: 'gray', width: '100%'}}
                    activityState={ActivityState.ATTACHED}>
                    <TouchableOpacity
                      style={{backgroundColor: 'red', width: 100, height: 100}}
                      onPress={() => {
                        setState(true);
                      }}
                    />
                  </Screen>
                );
              }}
              assert={({expect, state}) => {
                expect(state).to.be.true;
              }}
            />
            <TestCase itShould="show nothing (DETACH)">
              <Screen
                enabled={false}
                style={{backgroundColor: 'gray', width: '100%'}}
                activityState={ActivityState.DETACH}>
                <View
                  style={{backgroundColor: 'red', width: 100, height: 100}}
                />
              </Screen>
            </TestCase>
            <TestCase
              itShould="show rectangle on gray background and be clickable (IN_TRANSITION)"
              initialState={false}
              arrange={({setState}) => {
                return (
                  <Screen
                    enabled={false}
                    style={{backgroundColor: 'gray', width: '100%'}}
                    activityState={ActivityState.IN_TRANSITION}>
                    <TouchableOpacity
                      style={{backgroundColor: 'red', width: 100, height: 100}}
                      onPress={() => {
                        setState(true);
                      }}
                    />
                  </Screen>
                );
              }}
              assert={({expect, state}) => {
                expect(state).to.be.true;
              }}
            />
          </TestSuite>
        </TestSuite>
      </Tester>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: '100%',
  },
});

export default App;
