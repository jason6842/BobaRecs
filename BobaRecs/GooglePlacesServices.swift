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
}
