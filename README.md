# ReactNative-iOS13-BackgroundLocationFetch-RnNativeModule
 Changed iOS13 behaviour for background location fetch, with iOS native Modules and react-native.
 
 ### As iOS 13 has changed its behaviour for permission , as per WWDC 2019 , now you have to do special request to permit always allow.
 
 # So this project is made to understand , how can we leverage the background location fetch in iOS. 
 
 SO it s written in React-Native as well as iOS native module is also written in /ios folder. You can check two swift files for Native modules.
 
 So making it work in iOS13 , we have set Background Timer for 30 seconds, more than this will never allow to background fetch. SO keep it <=30 seconds always. And change the update server timing . And can check in iOS simulator by freeway drive or city run. 
 Another alternative is you can do significant Update , means whenever there will be significant update in location will happen , location will be update.(It is not implemented in this project, you can checkout in google for this.)
 
 
 ## For Installation: -
 
 ### Go to this folder & npm install
 
 #### For running in iOS simulator: -
 
 ### npx react-native run-ios
 
 
 # Ask if you have any doubt or you want to collaborate for android module. 
 
 #### Keep supporting, Keep Coding Cheers :)

