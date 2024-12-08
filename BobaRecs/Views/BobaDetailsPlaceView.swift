//
//  BobaDetailsPlaceView.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/5/24.
//

import SwiftUI

struct BobaDetailsPlaceView: View {
    @State private var photoReferences: [String] = []
    let place: Place
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Displays photo carousel
                if !place.photoReferences.isEmpty {
                    PhotoCarouselView(photoReferences: place.photoReferences)
                } else {
                    ProgressView("Loading photos")
                        .onAppear() {
                            GooglePlacesService.shared.fetchPlaceDetails(for: place.placeID) { photos in
                                DispatchQueue.main.async {
                                    self.photoReferences = photos	
                                }
                            }
                        }
                }

                // Place details
                VStack(alignment: .leading, spacing: 8) {
                    Text(place.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(place.address)
                        .font(.body)
                        .foregroundColor(.secondary)
                    Text("Coordinates: \(place.latitude), \(place.longitude)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Price: \(place.priceLevel != nil ? String(repeating: "$", count: place.priceLevel) : "N/A")")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("Price Level: \(place.priceLevel)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Likelihood: \(place.likelihood, specifier: "%.2f")")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
//            .navigationTitle(place.name)
////            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    @Previewable @EnvironmentObject var appDelegate: AppDelegate
    BobaDetailsPlaceView(place: appDelegate.places[0])
}
