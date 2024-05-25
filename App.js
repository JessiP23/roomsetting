import * as React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import CameraScreen from './CameraScreen';
import DimensionsScreen from './DimensionsScreen';
import RoomViewer from './RoomViewer';

const Stack = createStackNavigator();

const App = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Camera">
        <Stack.Screen name="Camera" component={CameraScreen} />
        <Stack.Screen name="Dimensions" component={DimensionsScreen} />
        <Stack.Screen name="RoomViewer" component={RoomViewer} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;
