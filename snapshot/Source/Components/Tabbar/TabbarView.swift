//
//  TabbarVieww.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI



struct TabbarView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var currentTab: Tab = .album
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                Header()
                if currentTab == .album {
                    AlbumView()
                } else if currentTab == .camera {
                    CameraView(currentTab: $currentTab)
                } else if currentTab == .setting {
                    SettingView()
                }
            }
            VStack {
                Spacer()
                Tabbar(currentTab: $currentTab)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.grey(for: colorScheme))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    TabbarView()
}
