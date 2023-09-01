/* eslint-disable react-native/no-inline-styles */
import React from 'react';
import {ScrollView, StyleSheet} from 'react-native';

function App({}): JSX.Element {
  return <ScrollView style={styles.container}></ScrollView>;
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: '100%',
  },
});

export default App;
