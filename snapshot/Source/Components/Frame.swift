//
//  Frame.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI

struct Frame: View {
    @Binding var selectedImages: [UIImage]
    @Binding var selectedFrame: String
    
    private let imageWidth: CGFloat = 120
    private let imageHeight: CGFloat = 164
    
    var body: some View {
        VStack {
            if !selectedImages.isEmpty {
                if selectedFrame.contains("Horizontal1") {
                        Image(selectedFrame)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)
                            .overlay{
                                HStack(alignment: .top, spacing: 15){
                                    VStack(alignment: .leading, spacing: 8){
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(width: 10, height: 88)
                
                                        
                                        Image(uiImage: selectedImages[0])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth, height: imageHeight)
                                            .clipped()
                                        Image(uiImage: selectedImages[1])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth, height: imageHeight)
                                            .clipped()
                                    }
                                    VStack(alignment: .leading, spacing: 8){
                                        Image(uiImage: selectedImages[2])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth, height: imageHeight)
                                            .clipped()
                                        Image(uiImage: selectedImages[3])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth, height: imageHeight)
                                            .clipped()
                                                                            
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(width: 10, height: 88)
                                    }
                                }
                                .clipped()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay{
                                    Image(selectedFrame)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 280)
                                }
                                .clipped()
                            }
                            
                        
                        
                        
                } else if selectedFrame.contains("Horizontal2") {

                    Image(selectedFrame)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280)
                        .overlay{
                            HStack(alignment: .top, spacing: 15){
                                VStack(alignment: .leading, spacing: 8){
                                    
                                    
                                    Image(uiImage: selectedImages[0])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth, height: imageHeight)
                                        .clipped()
                                    Image(uiImage: selectedImages[1])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth, height: imageHeight)
                                        .clipped()
                                    
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 10, height: 88)
                                }
                                VStack(alignment: .leading, spacing: 8){
                                    Image(uiImage: selectedImages[2])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth, height: imageHeight)
                                        .clipped()
                                    Image(uiImage: selectedImages[3])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth, height: imageHeight)
                                        .clipped()
                                    
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 10, height: 88)
                                }
                            }
                            .overlay{
                                Image(selectedFrame)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280)
                            }
                            .clipped()
                        }
                        
                    
                } else if selectedFrame.contains("Vertical") {
                    Image(selectedFrame)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .overlay{
                            VStack(alignment: .leading, spacing: 12){
                            
                                
                                Image(uiImage: selectedImages[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageHeight, height: imageWidth + 6)
                                    .clipped()
                                Image(uiImage: selectedImages[1])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageHeight, height: imageWidth + 6)
                                    .clipped()
                                Image(uiImage: selectedImages[2])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageHeight, height: imageWidth + 6)
                                    .clipped()
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10, height: 16)
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay{
                                Image(selectedFrame)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200)
                            }
                            .clipped()
                        }
                    }
                    
            }
        }
        
        
    }
}

