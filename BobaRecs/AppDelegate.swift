//
//  AppDelegate.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/1/24.
//

import UIKit
import GooglePlaces
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey("apikey")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
        fetchCurrentLocation()
        return true
    }
    
    func fetchCurrentLocation() {
        guard let placesClient = placesClient else { return }
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.name.rawValue) |
                                                                   UInt(GMSPlaceField.placeID.rawValue)))
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
          (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }

          if let placeLikelihoodList = placeLikelihoodList {
            for likelihood in placeLikelihoodList {
              let place = likelihood.place
              print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
              print("Current PlaceID \(String(describing: place.placeID))")
            }
          }
        })
    }
}
