//
//  ContentView.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate

    var body: some View {
        NavigationView {
            VStack {
                if appDelegate.places.isEmpty {
                    Text("No places found.")
                        .font(.headline)
                } else {
                    List(appDelegate.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text(place.address)
                                .font(.subheadline)
                            Text("Coordinates: \(place.latitude), \(place.longitude)")
                                .font(.caption)
                            Text("Rating: \(place.rating)")
                                .font(.caption)
                            Text("Likelihood: \(place.likelihood, specifier: "%.2f")")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Nearby Places")
        }
    }
}

#Preview {
    ContentView()
}
