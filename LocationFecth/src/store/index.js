import { createStore, combineReducers, applyMiddleware } from "redux";
import   { locReducer } from  "../reducers/Location"
import thunk from "redux-thunk";




export const store = createStore(locReducer, applyMiddleware(thunk))