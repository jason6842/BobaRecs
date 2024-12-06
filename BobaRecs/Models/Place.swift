//
//  Place.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/3/24.
//

import Foundation
import CoreLocation
import GooglePlaces

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let likelihood: Double
    var distance: Double?
    let rating: Double
    var photoReference: String? // Store photo reference as a string
}
