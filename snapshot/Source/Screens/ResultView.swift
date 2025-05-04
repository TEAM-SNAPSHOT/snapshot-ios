//
//  ResultView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var photoStore = PhotoStore.shared
    @State private var selectedImages: [UIImage] = []
    @State private var selectedFrame = UserDefaults.standard.string(forKey: "selectedFrame") ?? "Horizontal1 Frame 1"
    
    private let imageWidth: CGFloat = 120
    private let imageHeight: CGFloat = 164
    
    var body: some View {
        VStack {
            HStack{
                Button {
                    dismiss()
                    photoStore.images.removeAll()
                    photoStore.selectedImages.removeAll()
                    UserDefaults.standard.removeObject(forKey: "selectedFrame")
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            Spacer()
            
            if !selectedImages.isEmpty {
                if selectedFrame.contains("Horizontal1") {
                    ZStack {
                        Image(selectedFrame)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)
                            
                        
                        HStack(alignment: .top, spacing: 16){
                            VStack(alignment: .leading, spacing: 8){
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10, height: 88)
                                
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
                                
                                Image(uiImage: photoStore.selectedImages[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                Image(uiImage: photoStore.selectedImages[1])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                            }
                            VStack(alignment: .leading, spacing: 8){
                                Image(uiImage: photoStore.selectedImages[2])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                Image(uiImage: photoStore.selectedImages[3])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
                                
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10, height: 88)
                            }
                        }
                        
                    }
                } else if selectedFrame.contains("Horizontal2") {
                    ZStack {
                        Image(selectedFrame)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)
                            
                        
                        HStack(alignment: .top, spacing: 16){
                            VStack(alignment: .leading, spacing: 8){
                                
                                
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
                                
                                Image(uiImage: photoStore.selectedImages[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                Image(uiImage: photoStore.selectedImages[1])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10, height: 88)
                            }
                            VStack(alignment: .leading, spacing: 8){
                                Image(uiImage: photoStore.selectedImages[2])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                Image(uiImage: photoStore.selectedImages[3])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageHeight)
                                
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
        //                        Rectangle()
        //                            .fill(Color.red)
        //                            .frame(width: imageWidth, height: imageHeight)
                                
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10, height: 88)
                            }
                        }
                        
                    }
                }
            }
            
            
            
            Spacer()
            Button{
               
            } label: {
                HStack{
                    Text("공유하기")
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color(hex: "FFFFFF"))
                .background(Color.main)
                .roundedCorners(8, corners: [.allCorners])
            }
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(Color.grey(for: colorScheme))
        .navigationBarBackButtonHidden(true)
        .onAppear{
            selectedImages = photoStore.selectedImages
        }
        .onDisappear{
            photoStore.images.removeAll()
            photoStore.selectedImages.removeAll()
            UserDefaults.standard.removeObject(forKey: "selectedFrame")
            
        }
    }
}

#Preview {
    ResultView()
}
