//
//  AlbumView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI
import WaterfallGrid
import SwiftUIMasonry

struct AlbumView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = AlbumViewModel()
    @StateObject private var photoStore = PhotoStore.shared
    @State private var images: [UIImage] = []
    
    var body: some View {
        ScrollView {
            
            if(viewModel.images.isEmpty && !viewModel.isLoading){
                Text("스냅샷이 없습니다 :(")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray)
                    .padding(.top, 32)
            }
            
            Masonry(.vertical, lines: 3, spacing: 4){
                ForEach(viewModel.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 160)
            
        }
        .padding(.horizontal, 12)
        .foregroundStyle(Color.black(for: colorScheme))
        .onAppear {
            photoStore.images.removeAll()
            photoStore.selectedImages.removeAll()
            UserDefaults.standard.removeObject(forKey: "selectedFrame")
            
            viewModel.fetchPhotosFromAlbum(albumName: UserDefaults.standard.string(forKey: "albumName") ?? "")
            
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundStyle(Color.gray)
            }
        }
        .refreshable {
            viewModel.fetchPhotosFromAlbum(albumName: UserDefaults.standard.string(forKey: "albumName") ?? "")
        }
    }
}

#Preview {
    AlbumView()
}
