//
//  SortOptions.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/7/24.
//

import Foundation

enum SortOptions: String, CaseIterable {
    case priceHighToLow = "High to Low"
    case priceLowToHigh = "Low to High"
    case rating = "Rating"
    case distance = "Distance"
}
