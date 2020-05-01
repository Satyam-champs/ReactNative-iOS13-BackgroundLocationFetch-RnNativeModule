import { INITIATE_FETCH_LOCATION,
    RECEIVED_LOCATION } from '../ActionTypes'
import {NativeModules, NativeEventEmitter} from 'react-native'


export const fetchLocationReq = () => {
    return {
        type : INITIATE_FETCH_LOCATION
    }
};


export const receivedLocation = (locationData) => {
    return {
        type : RECEIVED_LOCATION,
        payload : locationData
    }
};



export const fetchLocation = () => {
    return (dispatch) => {
       /* console.log("fetchLocation")

        var data = { latitude : 'asd',
                     longitude : 'asdsd',
                     receivedDate : 'aasda',
                     address : 'dsds
                                fgfdg',
                     id : '123a'
                    }
        dispatch(receivedLocation(data)) */

        const eventEmitter = new NativeEventEmitter(NativeModules.LocationFetch);
        var locSub = eventEmitter.addListener(
            'EventLocation',
            (data) => {
                
                // console.log('lat : ' + data.latitude)
                console.log('long: ' + data.longitude)
                // console.log('receivedTS' + data.receivedDate)
                // console.log(data)
                // console.log('id: ' + data.id)
                // console.log('id: ' + data.address)

                dispatch(receivedLocation(data))
                
            }
          
          )
          
          NativeModules.LocationFetch.startBgLocationFetch() 

    }

};