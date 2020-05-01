/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import { createAppContainer } from "react-navigation";
import { createStackNavigator } from "react-navigation-stack";

import {Provider} from 'react-redux';
import { store } from "./src/store/index";


import LocationScreen from './src/components/Location/LocationScreen';


const baseNavigator = createStackNavigator({
  Home : LocationScreen
  },
  
  {
    initialRouteName: 'Home',
    defaultNavigationOptions: {
      title: 'Location Fetch',
    }
  });


const App =  createAppContainer(baseNavigator)

// const App = () => {
//   return <LocationScreen/>
// }

export default () => {
  return <Provider store = {store} >
            <App/>
          </Provider>

};
