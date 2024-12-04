//
//  AppDelegate.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/1/24.
//

import UIKit
import GooglePlaces
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, ObservableObject {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
    @Published var places: [Place] = []

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(APIKeys.googlePlacesAPIKey)
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
        fetchCurrentLocation()
        return true
    }
    
    func fetchCurrentLocation() {
        guard let placesClient = placesClient else { return }
        
        // Specify the fields of interest for the places
        let fields: GMSPlaceField = [.name, .placeID, .formattedAddress, .coordinate]
        
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) { [weak self] placeLikelihoodList, error in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            // Check if the placeLikelihoodList is available
            guard let placeLikelihoodList = placeLikelihoodList else {
                self?.places = [] // Assign an empty array if no results
                return
            }
            
            // Map the likelihoods into the places array
            self?.places = placeLikelihoodList.compactMap { likelihood in
                let place = likelihood.place // Likelihood contains a non-optional place
                return Place(
                    name: place.name ?? "Unknown", // Fallback if name is missing
                    address: place.formattedAddress ?? "No Address", // Fallback for address
                    latitude: place.coordinate.latitude, // Latitude
                    longitude: place.coordinate.longitude, // Longitude
                    likelihood: likelihood.likelihood // Likelihood score
                )
            }
        }
    }



}
