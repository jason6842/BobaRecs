//
//  ContentView.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    @State var showingBottomSheet = false
    @State private var selectedSortOption: SortOptions = .distance
    
    func getPlacesByCategory(by selectedSortOption: SortOptions) -> [Place] {
        switch selectedSortOption {
        case .priceHighToLow:
            return appDelegate.places.sorted { $0.priceLevel > $1.priceLevel }
        case .priceLowToHigh:
            return appDelegate.places.sorted { $0.priceLevel < $1.priceLevel }
        case .rating:
            return appDelegate.places.sorted { $0.rating > $1.rating }
        case .distance:
            return appDelegate.places.sorted { $0.distance ?? 0 < $1.distance ?? 0 }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if appDelegate.places.isEmpty {
                    Text("No places found.")
                        .font(.headline)
                } else {
                    List(getPlacesByCategory(by: selectedSortOption)) { place in
                        
                        NavigationLink(destination: BobaDetailsPlaceView(place: place)) {
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .font(.headline)
                                Text(place.address)
                                    .font(.subheadline)
                                Text("Coordinates: \(place.latitude), \(place.longitude)")
                                    .font(.caption)
                                Text("Rating: \(String(format: "%.1f", place.rating))")
                                    .font(.caption)
                                Text("Price: \(place.priceLevel != nil ? String(repeating: "$", count: place.priceLevel) : "N/A")")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Button tapped")
                        showingBottomSheet.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showingBottomSheet) {
                SortOptionsView(selectedOption: $selectedSortOption) // To determine which sortOption is chosen
                    .presentationDetents([.fraction(0.4), .medium])
            }
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
