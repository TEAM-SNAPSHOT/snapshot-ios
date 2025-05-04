//
//  PhotoLibraryViewModel.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//


import SwiftUI
import Photos

class AlbumViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    
    func fetchPhotosFromAlbum(albumName: String) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

                guard let album = collections.firstObject else { return }

                let assets = PHAsset.fetchAssets(in: album, options: nil)
                let imageManager = PHCachingImageManager()
                let targetSize = CGSize(width: 200, height: 200)

                var fetchedImages: [UIImage] = []

                assets.enumerateObjects { (asset, _, _) in
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    options.deliveryMode = .highQualityFormat

                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                        if let image = image {
                            fetchedImages.append(image)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.images = fetchedImages
                }
            }
        }
    }
}
