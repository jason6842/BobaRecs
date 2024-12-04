//
//  BobaRecsApp.swift
//  BobaRecs
//
//  Created by Jason Ma on 12/1/24.
//

import SwiftUI

@main
struct BobaRecsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
        }
    }
}
