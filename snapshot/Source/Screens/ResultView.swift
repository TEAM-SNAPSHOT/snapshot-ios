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
    @ObservedObject private var shareViewModel = ShareViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            if let image = photoStore.resultImage {
                Image(uiImage: image)
            }
                
            
            Spacer()
            Button{
                if let image = photoStore.resultImage {
                    shareViewModel.share(stickerImage: image)
                }
            } label: {
                HStack(alignment: .center, spacing: 8){
                    Text("스토리에 공유하기")
                    Image(systemName: "square.and.arrow.up")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.main)
                .roundedCorners(8, corners: [.allCorners])
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 24)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(Color.grey(for: colorScheme))
        .navigationBarBackButtonHidden(true)
        .onDisappear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UserDefaults.standard.removeObject(forKey: "selectedFrame")
                photoStore.resultImage = nil
            }
        }
    }
}

#Preview {
    ResultView()
}
