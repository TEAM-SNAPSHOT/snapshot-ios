//
//  ContentView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLaunch: Bool = true
    
    var body: some View {
        if isLaunch {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.linear) {
                            self.isLaunch = false
                        }
                    }
                }
        } else {
            NavigationStack {
                TabbarView()
            }
        }
    }
}

#Preview {
    ContentView()
}
