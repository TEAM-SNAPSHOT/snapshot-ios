//
//  ResultView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI
import Photos
import UIKit

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var photoStore = PhotoStore.shared
    @State private var selectedImages: [UIImage] = []
    @State private var selectedFrame = UserDefaults.standard.string(forKey: "selectedFrame") ?? "Horizontal1 Frame 1"
    
    @ObservedObject private var viewModel = ResultViewModel()
    
    
    var body: some View {
        VStack {
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(Color.black(for: colorScheme))
                }
                Spacer()
            }
            Spacer()
            
            Frame(selectedImages: $selectedImages, selectedFrame: $selectedFrame)
            
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
        .padding(.top, 24)
        .frame(maxWidth: .infinity)
        .background(Color.grey(for: colorScheme))
        .navigationBarBackButtonHidden(true)
        .onAppear{
            selectedImages = photoStore.selectedImages
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                captureView(of: Frame(selectedImages: $selectedImages, selectedFrame: $selectedFrame)) { image in
                    if let image = image {
                        viewModel.saveImageToAlbum(image, albumName: UserDefaults.standard.string(forKey: "albumName") ?? "스냅샷") { success, error in
                            if success {
                                print("이미지가 성공적으로 저장되었습니다!")
                            } else {
                                print("저장 실패: \(error ?? "알 수 없는 오류")")
                            }
                        }
                    }
                }
                
                photoStore.images.removeAll()
                photoStore.selectedImages.removeAll()
            }
            
        }
        .onDisappear{
            UserDefaults.standard.removeObject(forKey: "selectedFrame")
        }
    }
}

#Preview {
    ResultView()
}
