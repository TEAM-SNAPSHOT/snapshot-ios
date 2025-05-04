//
//  snapshotApp.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI

@main
struct snapshotApp: App {
    @AppStorage("darkMode") private var isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
