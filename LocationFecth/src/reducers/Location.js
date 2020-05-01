
import { RECEIVED_LOCATION } from '../ActionTypes'

const initialState = {
    locationsList : []
    
}

export const locReducer = (state = initialState, action) => {
    
    switch (action.type) {
        case RECEIVED_LOCATION: 
        // Logic to be implemneted for previous and current location check 
        // Pushing into array logic to be updated
         var locations  = state.locationsList;
         if (locations.length > 0) {
             var object = locations[locations.length - 1]
             if (object.id != action.payload.id) {
                locations.push(action.payload)
             }
         } else {
            locations.push(action.payload)
         }

        return {
            ...state, 
            locationsList : [...locations]
        }

        default: 
        return state
    }

}