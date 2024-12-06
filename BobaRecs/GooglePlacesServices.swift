//
//  GooglePlacesServices.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/5/24.
//

import Foundation
import UIKit

class GooglePlacesService {
    static let shared = GooglePlacesService() // Singleton for easy access

    private init() {}

    func fetchPhoto(with photoReference: String, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=\(APIKeys.googlePlacesAPIKey)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid photo URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching photo: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load photo data")
                completion(nil)
                return
            }

            completion(image)
        }.resume()
    }
    
    func fetchPlaceDetails(for placeID: String, completion: @escaping ([String]) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeID)&fields=photos&key=\(APIKeys.googlePlacesAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid Place Details URL for placeID: \(placeID)")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Place Details for placeID \(placeID): \(error.localizedDescription)")
                completion([]) // Ensure completion is always called
                return
            }

            guard let data = data else {
                print("No data returned for Place Details request for placeID \(placeID)")
                completion([])
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let result = json?["result"] as? [String: Any],
                      let photos = result["photos"] as? [[String: Any]] else {
                    print("No photos found in Place Details for placeID \(placeID)")
                    completion([]) // Ensure completion is called even if no photos
                    return
                }

                let photoReferences = photos.compactMap { $0["photo_reference"] as? String }
                print("Photo References for placeID \(placeID): \(photoReferences)") // Debugging
                completion(photoReferences)
            } catch {
                print("Error parsing Place Details JSON for placeID \(placeID): \(error.localizedDescription)")
                completion([]) // Ensure completion is always called
            }
        }.resume()
    }

}
