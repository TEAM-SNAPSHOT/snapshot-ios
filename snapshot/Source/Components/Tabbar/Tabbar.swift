//
//  Tabbar.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI
import FlexibleKit

enum Tab {
    case album
    case camera
    case setting
}

struct Tabbar: View {
    @Binding var currentTab: Tab;
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            HStack {
                Button {
                    currentTab = .album
                } label: {
                    VStack(alignment: .center, spacing: 4){
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 24))
                        Text("앨범")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(currentTab == .album ? Color.main :.gray)
                }
                .disabled(currentTab == .album)
                
                Spacer()
                
                
                Button {
                    currentTab = .setting
                } label: {
                    VStack(alignment: .center, spacing: 4){
                        Image(systemName: "gearshape")
                            .font(.system(size: 24))
                        Text("설정")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(currentTab == .setting ? Color.main : .gray)
                }
                .disabled(currentTab == .setting)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal, UIScreen.main.bounds.width / 3 - 56)
            .padding(.bottom, 28)
            .padding(.top, 16)
            .background(Color.white(for: colorScheme))
            .roundedCorners(30, corners: [.topLeft, .topRight])
            
            VStack {
                Button {
                    currentTab = .camera
                } label: {
                    VStack(alignment: .center, spacing: 4){
                        Image(systemName: "plus")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .frame(width: 64, height: 64)
                    .background(Color.main)
                    .cornerRadius(100)
                }
                .disabled(currentTab == .camera)
                Spacer()
            }
            .frame(height: 100)
        }
        .shadow(color: Color.gray.opacity(0.2), radius: 4)
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

#Preview {
    Tabbar(currentTab: .constant(.album))
}
