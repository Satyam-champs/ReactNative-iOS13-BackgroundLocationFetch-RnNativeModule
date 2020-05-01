//
//  BackgroundLocationManager.swift
//
//  Created by Satyam on 08/04/20.
//

import Foundation
import CoreLocation
import UIKit

protocol BgLocationManagerDelegate {
  func sendLocation(location:CLLocation, now:NSDate)
}

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {

    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 30.0 // restart location manager time in seconds, in iOS >= 13 it doesn't work in background,  if we put more than 30. 
    static let UPDATE_SERVER_INTERVAL = 1 * 60 //Here data will update in server in this interval in seconds, although data will be updated as per background timer in the device

    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()
    var isFirstLocationSent = false

    var delegate : BgLocationManagerDelegate?

    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
//        if #available(iOS 9, *){
            locationManager.allowsBackgroundLocationUpdates = true
      locationManager.pausesLocationUpdatesAutomatically = false
//        }

      NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

  @objc func applicationEnterBackground(){
        start()
    }

    func start(){
//      if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
          locationManager.startUpdatingLocation()
//            if #available(iOS 9, *){
//                locationManager.requestLocation()
//            } else {
//                locationManager.startUpdatingLocation()
//            }
//        } else {
//                locationManager.requestAlwaysAuthorization()
       
//        }
      print("###########\(CLLocationManager.authorizationStatus().rawValue)")
    }
  @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }


  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case CLAuthorizationStatus.restricted:
            print("Restricted Access to location")
            break
        case CLAuthorizationStatus.denied:
            print("User denied access to location")
            break
        case CLAuthorizationStatus.notDetermined:
            print("Status not determined")
            break
        case CLAuthorizationStatus.authorizedWhenInUse:
          print("!!!!!!!!!!!!!!!!!!!!!!When In Use")
          locationManager.requestAlwaysAuthorization()
        case CLAuthorizationStatus.authorizedAlways:
          print("*******Always")
        default:
          NSLog("startUpdatintLocation")
          locationManager.startUpdatingLocation()
            //log("startUpdatintLocation")
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if(timer==nil){
            // The locations array is sorted in chronologically ascending order, so the
            // last element is the most recent
            guard let location = locations.last else {return}

            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()

          for loc in locations {
            NSLog("locationManager ==> %lf, %lf", loc.coordinate.latitude, loc.coordinate.longitude)
          }

          let now = NSDate()

          if !isFirstLocationSent {
            lastLocationDate = NSDate()
            sendLocationToNeedy(location: location, now:now)
            isFirstLocationSent = true
          } else if(isItTime(now: now)){
            lastLocationDate = NSDate()
            sendLocationToNeedy(location: location, now:now)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()
    }

    func isItTime(now:NSDate) -> Bool {
      let timePast = now.timeIntervalSince(lastLocationDate as Date)
        let intervalExceeded = Int(timePast) > BackgroundLocationManager.UPDATE_SERVER_INTERVAL
        return intervalExceeded;
    }

    func sendLocationToNeedy(location:CLLocation, now:NSDate){
      delegate?.sendLocation(location: location, now: now)
    }

    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
      currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {

        })
        if let taskId = previousTaskId{
          UIApplication.shared.endBackgroundTask(taskId)
          previousTaskId = UIBackgroundTaskIdentifier.invalid
        }

      timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
    }
}
