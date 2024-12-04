//
//  CLLLocationExtension.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/3/24.
//

import Foundation
import CoreLocation

extension CLLocation {
    // Calculate the distance to another location
    func distance(to location: CLLocation) -> Double {
        return self.distance(from: location)
    }
}
