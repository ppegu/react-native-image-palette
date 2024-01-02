import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { multiply, getColors } from 'react-native-image-palette';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    multiply(3, 4).then(setResult);

    getColors('https://i.ytimg.com/vi/WWr9086eWtY/maxresdefault.jpg')
      .then((data) => {
        console.log('data', data);
      })
      .catch(console.error)
      .finally(() => console.log('completed'));
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
