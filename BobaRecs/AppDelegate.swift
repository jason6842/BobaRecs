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
    
//    func fetchCurrentLocation() {
//        guard let placesClient = placesClient else { return }
//        
//        // Specify the fields of interest for the places
//        let fields: GMSPlaceField = [.name, .placeID, .formattedAddress, .coordinate]
//        
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) { [weak self] placeLikelihoodList, error in
//            if let error = error {
//                print("An error occurred: \(error.localizedDescription)")
//                return
//            }
//            
//            // Check if the placeLikelihoodList is available
//            guard let placeLikelihoodList = placeLikelihoodList else {
//                self?.places = [] // Assign an empty array if no results
//                return
//            }
//            
//            // Map the likelihoods into the places array
//            self?.places = placeLikelihoodList.compactMap { likelihood in
//                let place = likelihood.place // Likelihood contains a non-optional place
//                return Place(
//                    name: place.name ?? "Unknown", // Fallback if name is missing
//                    address: place.formattedAddress ?? "No Address", // Fallback for address
//                    latitude: place.coordinate.latitude, // Latitude
//                    longitude: place.coordinate.longitude, // Longitude
//                    likelihood: likelihood.likelihood // Likelihood score
//                )
//            }
//        }
//    }
    
    
    func fetchCurrentLocation() {
        // Get the user's current location
        guard let currentLocation = locationManager.location else {
            print("Location not available")
            return
        }

        // API parameters
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        let radius = 1600 // Search within 1 km
        let keyword = "boba"
        let apiKey = APIKeys.googlePlacesAPIKey

        // Construct the API URL
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Perform the network request
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching places: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                // Decode the JSON response
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let results = json?["results"] as? [[String: Any]] else { return }

                // Map the results to Place objects
                let bobaPlaces = results.compactMap { result -> Place? in
                    guard
                        let name = result["name"] as? String,
                        let address = result["vicinity"] as? String,
                        let geometry = result["geometry"] as? [String: Any],
                        let location = geometry["location"] as? [String: Any],
                        let rating = result["rating"] as? Double,
                        let lat = location["lat"] as? Double,
                        let lng = location["lng"] as? Double,
                        let placeID = result["place_id"] as? String

                            
                            
                    else { return nil }
                   
                    // Extract photo metadata
//                    let photoReferences: [String] = {
//                        if let photos = result["photos"] as? [[String: Any]] {
////                            print(photos)
//                            let references = photos.compactMap { $0["photo_reference"] as? String } // compactMap discards all the nil values
////                            print("Photo References for \(name): \(references)")
////                            print(references.count)
//                            
//                            return references
//                        }
//                        return []
//                    }()
                    
                    
                    return Place(
                        name: name,
                        address: address,
                        latitude: lat,
                        longitude: lng,
                        likelihood: 0, // Likelihood is not provided by Nearby Search,
                        rating: rating,
                        placeID: placeID,
                        photoReferences: []
                    )
                }

                DispatchQueue.main.async {
                    self?.places = bobaPlaces
                    
                    bobaPlaces.forEach { place in
                        GooglePlacesService.shared.fetchPlaceDetails(for: place.placeID) { photoReferences in
                            if let index = self?.places.firstIndex(where: { $0.placeID == place.placeID }) {
                                DispatchQueue.main.async {
                                    self?.places[index].photoReferences = photoReferences
                                    print("Photo References for placeID \(place.placeID): \(place.photoReferences)")
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }




}
