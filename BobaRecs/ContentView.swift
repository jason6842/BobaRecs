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
                        
                        NavigationLink(destination: BobaDetailsPlaceView(place: place)) {
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
            }
            .navigationTitle("Nearby Places")
        }
    }
}

// AsyncImage view for Loading Photos
struct AsyncImage: View {
    let photoReference: String
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width - 32) // Make it fit within the screen
                    .clipped() // Prevents overflow outside of the frame
            } else {
                ProgressView()
                    .onAppear {
                        GooglePlacesService.shared.fetchPhoto(with: photoReference) { fetchedImage in
                            DispatchQueue.main.async {
                                self.image = fetchedImage
                            }
                        }
                    }
            }
        }
    }
}

struct PhotoCarouselView: View {
    let photoReferences: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
//                print(photoReferences)
                ForEach(photoReferences, id: \.self) { reference in
                    AsyncImage(photoReference: reference)
                        .frame(width: UIScreen.main.bounds.width - 32) // Limit the image's width
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
