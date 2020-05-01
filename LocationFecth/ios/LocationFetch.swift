//
//  LocationFecth.swift
//  LocFetchApp
//
//  Created by Satyam on 10/04/20.
//

import Foundation
import MapKit
import CoreLocation
import Contacts

@objc(LocationFetch)

class LocationFetch : RCTEventEmitter, BgLocationManagerDelegate {

  override class func requiresMainQueueSetup() -> Bool {
    return true
  }

  override func supportedEvents() -> [String]! {
    return ["EventHello", "EventLocation"]
  }

  @objc func startBgLocationFetch( ) -> Void {

    DispatchQueue.main.async {
      let ins = BackgroundLocationManager.instance
      ins.delegate = self
      ins.start()
    }
  }

  func sendLocation(location: CLLocation, now: NSDate) {

    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
    let formattedDate = formatter.string(from: date)
    let idVal = formattedDate+UUID().uuidString
     var place: String?
     let address = CLGeocoder.init()
     address.reverseGeocodeLocation(CLLocation.init(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)) { (places, error) in
         if error == nil{
//           place = places?[0]
//          let formatter = CNPostalAddressFormatter()
//          if #available(iOS 11.0, *) {
//            place = formatter.string(from: (places?[0].postalAddress)!)
//            place = place?.replacingOccurrences(of: "\n", with: ", ", options: .regularExpression)
//          } else {
//            // Fallback on earlier versions
//            place = String(betterMethod: places?.first)
//          }
          place = String(betterMethod: places?.first)
          let body =      [
                "latitude": location.coordinate.latitude,
                 "longitude" : location.coordinate.longitude,
                 "receivedDate" : formattedDate ,
                 "address": place,
                 "id" : idVal
               ] as [String : Any]

          self.sendEvent(withName: "EventLocation", body: body)
         }
     }

    

  }

  @objc func printHello1(_ name: String ) -> Void {

    NSLog("%@ ", name)


    for idx in 0...3 {
      let body =      [
        "name": name,
        "idx" : idx
      ] as [String : Any]

      self.sendEvent(withName: "EventHello", body: body)
    }


    let body =      [
      "name": "name",
      "idx" : "idx"
    ] as [String : Any]
    self.sendEvent(withName: "EventHello", body: body)
  }


}
//MARK: - It is for address change
extension String {
//    // original method (edited)
//    init?(depreciated placemark1: CLPlacemark?) {
//    // UPDATE: **addressDictionary depreciated in iOS 11** dep
//        guard
//            let myAddressDictionary = placemark1?.addressDictionary,
//            let myAddressLines = myAddressDictionary["FormattedAddressLines"] as? [String]
//    else { return nil }
//
//        self.init(myAddressLines.joined(separator: " "))
//}

    // my preferred method - let CNPostalAddressFormatter do the heavy lifting
    init?(betterMethod placemark2: CLPlacemark?) {
        // where the magic is:
      let postalAddress = CNMutablePostalAddress(placemark: placemark2!)
        self.init(CNPostalAddressFormatter().string(from: postalAddress))
    }
}

///Here it is made for changing the location parameters of longitude and latitude in Address
extension CNMutablePostalAddress {
    convenience init(placemark: CLPlacemark) {
        self.init()
        street = [placemark.subThoroughfare, placemark.thoroughfare]
            .compactMap { $0 }           // remove nils, so that...
            .joined(separator: " ")      // ...only if both != nil, add a space.
    /*
    // Equivalent street assignment, w/o flatMap + joined:
        if let subThoroughfare = placemark.subThoroughfare,
            let thoroughfare = placemark.thoroughfare {
            street = "\(subThoroughfare) \(thoroughfare)"
        } else {
            street = (placemark.subThoroughfare ?? "") + (placemark.thoroughfare ?? "")
        }
    */
        city = placemark.locality ?? ""
        state = placemark.administrativeArea ?? ""
        postalCode = placemark.postalCode ?? ""
        country = placemark.country ?? ""
        isoCountryCode = placemark.isoCountryCode ?? ""
        if #available(iOS 10.3, *) {
            subLocality = placemark.subLocality ?? ""
            subAdministrativeArea = placemark.subAdministrativeArea ?? ""
        }
    }
}
