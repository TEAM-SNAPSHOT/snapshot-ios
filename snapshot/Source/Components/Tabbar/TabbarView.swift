//
//  TabbarVieww.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI



struct TabbarView: View {
    @State var currentTab: Tab = .album
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                Header()
                if currentTab == .album {
                    AlbumView()
                } else if currentTab == .camera {
                    CameraView()
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
        .background(Color.grey)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    TabbarView()
}
