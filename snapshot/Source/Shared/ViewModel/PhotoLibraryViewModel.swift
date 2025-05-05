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
    @Published var isLoading: Bool = false
    
    func fetchPhotosFromAlbum(albumName: String) {
        self.isLoading = true
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                
                print(albumName)
                
                guard let album = self.fetchAssetCollection(for: albumName.isEmpty ? "스냅샷" : albumName) else {
                    print("앨범을 찾을 수 없습니다.")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }

                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)

                let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
                print("📸 앨범 내 사진 수: \(assets.count)")

                let imageManager = PHCachingImageManager()
                let targetSize = CGSize(width: 2000, height: 2000) // 더 큰 사이즈로 변경

                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                requestOptions.deliveryMode = .highQualityFormat

                var fetchedImages: [UIImage] = []
                
                assets.enumerateObjects { (asset, _, _) in
                    imageManager.requestImage(
                        for: asset,
                        targetSize: targetSize,
                        contentMode: .aspectFit,
                        options: requestOptions
                    ) { image, info in
                        if let image = image {
                            DispatchQueue.main.async {
                                fetchedImages.append(image)
                                print("✅ 이미지 추가됨")
                            }
                        } else {
                            print("❌ 이미지 로드 실패 for asset: \(asset)")
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.images = fetchedImages
                    self.isLoading = false
                    print(fetchedImages)
                }
            } else {
                print("사진 접근 권한이 없습니다.")
            }
        }
        self.isLoading = false
    }
    
    private func fetchAssetCollection(for albumName: String) -> PHAssetCollection? {
        let allAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        var matched: PHAssetCollection?
        
        allAlbums.enumerateObjects { collection, _, stop in
            if collection.localizedTitle == albumName {
                matched = collection
                stop.pointee = true
            }
        }
        
        return matched
    }

    
    func printAllAlbums() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
                userAlbums.enumerateObjects { collection, _, _ in
                    print("앨범 이름: \(collection.localizedTitle ?? "알 수 없음")")
                }
            } else {
                print("사진 접근 권한이 없습니다.")
            }
        }
    }
    
    
}
