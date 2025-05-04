//
//  AlbumView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI
import WaterfallGrid

struct AlbumView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = AlbumViewModel()
    @StateObject private var photoStore = PhotoStore.shared
    
    var body: some View {
        ScrollView {
            WaterfallGrid(viewModel.images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipped()
            }
            .gridStyle(
                columns: 3,
                spacing: 4,
                animation: .none
            )
            .padding(.top, 12)
            .padding(.bottom, 160)
        }
        .padding(.horizontal, 12)
        .foregroundStyle(Color.black(for: colorScheme))
        .onAppear {
            viewModel.fetchPhotosFromAlbum(albumName: UserDefaults.standard.string(forKey: "albumName") ?? "스냅샷")
            photoStore.images.removeAll()
            photoStore.selectedImages.removeAll()
            UserDefaults.standard.removeObject(forKey: "selectedFrame")
        }
    }
}

#Preview {
    AlbumView()
}
