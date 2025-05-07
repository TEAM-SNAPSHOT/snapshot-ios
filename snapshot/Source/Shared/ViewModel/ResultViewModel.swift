//
//  ResultViewModel.swift
//  snapshot
//
//  Created by cher1shRXD on 5/5/25.
//

import UIKit
import Photos
import SwiftUI

class ResultViewModel: ObservableObject {
    // MARK: - 이미지 저장 메인 함수
    func saveImageToAlbum(_ image: UIImage, albumName: String, completion: @escaping (Bool, String?) -> Void) {
        // 먼저 알파 채널 처리 (오류 방지)
        let processedImage = processImageForSaving(image)
        
        // 권한 확인
        checkPhotoLibraryPermission { [weak self] hasPermission in
            guard let self = self, hasPermission else {
                completion(false, "사진 라이브러리 접근 권한이 없습니다.")
                return
            }
            
            // 앨범 확인 및 처리
            self.getOrCreateAlbum(named: albumName) { success, album, error in
                if success, let album = album {
                    self.saveImageToAlbum(processedImage, album: album, completion: completion)
                } else {
                    // 앨범 처리 실패 - 기본 카메라롤에만 저장
                    self.saveImageToLibraryOnly(processedImage, completion: completion)
                }
            }
        }
    }
    
    // MARK: - 사진 라이브러리 권한 처리
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let currentStatus: PHAuthorizationStatus
        
        if #available(iOS 14, *) {
            currentStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            currentStatus = PHPhotoLibrary.authorizationStatus()
        }
        
        switch currentStatus {
        case .authorized:
            completion(true)
            
        case .limited:
            // 제한된 권한도 일단 허용
            completion(true)
            
        case .denied, .restricted:
            completion(false)
            
        case .notDetermined:
            // 권한 요청
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    DispatchQueue.main.async {
                        completion(status == .authorized || status == .limited)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        completion(status == .authorized)
                    }
                }
            }
            
        @unknown default:
            completion(false)
        }
    }
    
    private func getOrCreateAlbum(named albumName: String, completion: @escaping (Bool, PHAssetCollection?, String?) -> Void) {
        let albumName = albumName.isEmpty ? "스냅샷" : albumName
        
        if let existingAlbum = fetchAlbumByName(albumName) {
            print("기존 앨범 '\(albumName)'을(를) 찾았습니다.")
            completion(true, existingAlbum, nil)
            return
        }
        
        print("새 앨범 '\(albumName)'을(를) 생성합니다.")
        
        createAlbum(named: albumName) { success, album, error in
            if success, let album = album {
                print("앨범 '\(albumName)'이(가) 성공적으로 생성되었습니다.")
                completion(true, album, nil)
            } else {
                print("앨범 생성 실패: \(error ?? "알 수 없는 오류")")
                completion(false, nil, error)
            }
        }
    }
    
    private func fetchAlbumByName(_ albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: fetchOptions
        )
        
        if let album = userCollections.firstObject {
            return album
        }
        
        let otherCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )
        
        return otherCollections.firstObject
    }
    
    private func createAlbum(named albumName: String, completion: @escaping (Bool, PHAssetCollection?, String?) -> Void) {
        if let existingAlbum = fetchAlbumByName(albumName) {
            completion(true, existingAlbum, nil)
            return
        }
        
        var placeholder: PHObjectPlaceholder?
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }
            
            if let placeholder = placeholder {
                let collection = PHAssetCollection.fetchAssetCollections(
                    withLocalIdentifiers: [placeholder.localIdentifier],
                    options: nil
                )
                
                if let album = collection.firstObject {
                    completion(true, album, nil)
                } else {
                    completion(false, nil, "앨범을 찾을 수 없습니다.")
                }
            } else {
                completion(false, nil, "앨범 생성 플레이스홀더가 없습니다.")
            }
        } catch let error {
            completion(false, nil, "앨범 생성 오류: \(error.localizedDescription)")
        }
    }
    
    
    private func saveImageToAlbum(_ image: UIImage, album: PHAssetCollection, completion: @escaping (Bool, String?) -> Void) {
        do {
            var assetPlaceholder: PHObjectPlaceholder?
            
            try PHPhotoLibrary.shared().performChangesAndWait {
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                
                guard let assetPlaceholder = assetPlaceholder,
                      let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                    return
                }
                
                let fastEnumeration = NSArray(object: assetPlaceholder)
                albumChangeRequest.addAssets(fastEnumeration)
            }
            
            completion(true, nil)
        } catch let error {
            print("앨범에 저장 실패: \(error.localizedDescription)")
            saveImageToLibraryOnly(image, completion: completion)
        }
    }
    
    private func saveImageToLibraryOnly(_ image: UIImage, completion: @escaping (Bool, String?) -> Void) {
        self.saveImageCompletion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private var saveImageCompletion: ((Bool, String?) -> Void)?
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            saveImageCompletion?(false, "이미지 저장 실패: \(error.localizedDescription)")
        } else {
            saveImageCompletion?(true, nil)
        }
        saveImageCompletion = nil
    }
    
    
    private func processImageForSaving(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: image.size))
        

        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? image
    }
}
