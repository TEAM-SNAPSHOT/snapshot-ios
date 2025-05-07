//
//  SettingView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("darkMode") private var isDarkMode: Bool = UITraitCollection.current.userInterfaceStyle == .dark
    
    @StateObject private var photoStore = PhotoStore.shared
    
    @AppStorage("albumName") private var albumName: String = "스냅샷"

    var body: some View {
        VStack(alignment: .leading){
            Text("설정")
                .font(.system(size: 20))
            VStack(spacing: 12){
                Toggle("다크모드", isOn: $isDarkMode)
                
                Divider()
                
                HStack {
                    Text("앨범 이름")
                    Spacer()
                    TextField(albumName.isEmpty ? "스냅샷" : albumName, text: $albumName)
                        .frame(width: 120)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.gray.opacity(0.2))
                        .roundedCorners(8, corners: [.allCorners])
                        .hideKeyBoard()
                }
                
                Divider()
                
                VStack{
                    HStack {
                        Text("촬영 시간")
                        Spacer()
                        NumericTextField()
                        Text("초")
                    }
                    HStack{
                        Text("3초 이상, 16초 이하로 입력해주세요.")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    
                }
                
                
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.container(for: colorScheme))
            .roundedCorners(12, corners: [.allCorners])
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 24)
            
            Text("크레딧")
                .font(.system(size: 20))
            VStack(spacing: 12){
                HStack {
                    Text("Github")
                    Spacer()
                    Link(destination: URL(string: "https://github.com/cher1shRXD")!) {
                        Text("cher1shRXD")
                            .foregroundStyle(.blue)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Instagram")
                    Spacer()
                    Link(destination: URL(string: "https://www.instagram.com/cher1sh_rxd/")!) {
                        Text("@cher1sh_rxd")
                            .foregroundStyle(.blue)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Notion")
                    Spacer()
                    Link(destination: URL(string: "https://bolder-lemon-5f0.notion.site/38f7ab784fed439dba3897c9b0677841")!) {
                        Text("portfolio")
                            .foregroundStyle(.blue)
                    }
                }
                
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.container(for: colorScheme))
            .roundedCorners(12, corners: [.allCorners])
            
            Spacer()
        }
        .foregroundStyle(Color.black(for: colorScheme))
        .padding(.horizontal, 12)
        .padding(.vertical, 24)
        .onAppear {
            photoStore.images.removeAll()
            photoStore.selectedImages.removeAll()
            UserDefaults.standard.removeObject(forKey: "selectedFrame")
        }
        
    }
}


#Preview {
    SettingView()
}
