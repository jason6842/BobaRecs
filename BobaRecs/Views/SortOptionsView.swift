//
//  SortOptionsView.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/7/24.
//

import SwiftUI

struct SortOptionsView: View {
//    @State private var selectedOption: SortOptions = .distance // Default Selection
    @Binding var selectedOption: SortOptions // Binding to track the selected option
    @Environment(\.presentationMode) var presentationMode // Access the environment variable to control the sheet
    
    var body: some View {
        VStack (alignment: .leading){

            Text("Sort By")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.top)
//            Spacer()
            
            List(SortOptions.allCases, id: \.self) { option in
                HStack {
                    Text(option.rawValue)
                    Spacer()
                    ZStack {
                        // Outer circle
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        // Inner circle, filled when selected
                        if option == selectedOption {
                            Circle()
                                .fill(Color.pink)
                                .frame(width: 13, height: 13)
                        } else {
                            Circle()
                                .fill(Color.clear) // No fill when not selected
                                .frame(width: 13, height: 13)
                        }
                    }

                }
                .onTapGesture {
                    selectedOption = option
                    presentationMode.wrappedValue.dismiss()
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }
}

//#Preview {
//    SortOptionsView()
//}
