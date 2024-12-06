//
//  BobaDetailsPlaceView.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/5/24.
//

import SwiftUI

struct BobaDetailsPlaceView: View {
    let place: Place
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Photo or placeholder
                if let photoReference = place.photoReference {
                    AsyncImage(photoReference: photoReference)
                        .frame(width: 400, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.bottom, 16)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 400, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.bottom, 16)
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
                    Text("Rating: \(place.rating)")
                        .font(.caption)
                        .foregroundColor(.blue)
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
