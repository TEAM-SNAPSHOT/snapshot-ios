//
//  FilterView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/7/25.
//

import SwiftUI



struct FilterView: View {
    @Binding var currentTab: Tab
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var photoStore = PhotoStore.shared
    @State private var selectedImages: [UIImage] = []
    @State private var selectedFrame = UserDefaults.standard.string(forKey: "selectedFrame") ?? "Horizontal1 Frame 1"
    @State private var isSaved = false
    
    @ObservedObject private var resultViewModel = ResultViewModel()
    @ObservedObject private var viewModel = FilterViewModel()
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Frame(selectedImages: $viewModel.filteredImage, selectedFrame: $selectedFrame)
            
            Spacer()
            
            HStack {
                Spacer()
                Button{
                    viewModel.selectedFilter = .original
                } label: {
                    VStack{
                        Circle()
                            .fill(Color(hex: "FFDAB9"))
                            .frame(width: 32, height: 32)
                        Text("원본")
                            .font(.system(size: 10))
                    }
                }
                .disabled(viewModel.selectedFilter == .original)
                Spacer()
                Button{
                    viewModel.selectedFilter = .mono
                } label: {
                    VStack{
                        Circle()
                            .fill(Color(hex: "888888"))
                            .frame(width: 32, height: 32)
                        Text("흑백")
                            .font(.system(size: 10))
                    }
                }
                .disabled(viewModel.selectedFilter == .mono)
                Spacer()
                Button{
                    viewModel.selectedFilter = .bright
                } label: {
                    VStack{
                        Circle()
                            .fill(.white.opacity(0.9))
                            .frame(width: 32, height: 32)
                        Text("밝게")
                            .font(.system(size: 10))
                    }
                }
                .disabled(viewModel.selectedFilter == .bright)
                Spacer()
            }
            .foregroundStyle(.gray)
            
            Spacer()
            
            Button{
                captureView(of: Frame(selectedImages: $selectedImages, selectedFrame: $selectedFrame)) { image in
                    if let image = image {
                        resultViewModel.saveImageToAlbum(image, albumName: UserDefaults.standard.string(forKey: "albumName") ?? "스냅샷") { _, _ in }
                        photoStore.resultImage = image
                    }
                }
                isSaved = true
            } label: {
                HStack(alignment: .center, spacing: 8){
                    Text("저장하기")
                    Image(systemName: "square.and.arrow.down")
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
        .onAppear{
            selectedImages = photoStore.selectedImages
            viewModel.filteredImage = photoStore.selectedImages
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                captureView(of: Frame(selectedImages: $selectedImages, selectedFrame: $selectedFrame)) { image in
                    if let image = image {
                        PhotoStore.shared.resultImage = image
                    }
                }
                
                photoStore.images.removeAll()
                photoStore.selectedImages.removeAll()
            }
            
        }
        .onChange(of: viewModel.selectedFilter) { newValue in
            viewModel.applyFilter(filter: newValue, originalImages: self.selectedImages)
        }
        .navigationDestination(isPresented: $isSaved) {
            ResultView(currentTab: $currentTab)
        }
    }
}
