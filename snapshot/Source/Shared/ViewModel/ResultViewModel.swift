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
    
    // MARK: - 앨범 처리 함수들
    
    // 앨범 이름을 기준으로 가져오거나 없으면 생성
    private func getOrCreateAlbum(named albumName: String, completion: @escaping (Bool, PHAssetCollection?, String?) -> Void) {
        // 1. 먼저 앨범 존재 여부 확인
        let albumName = albumName.isEmpty ? "스냅샷" : albumName
        
        if let existingAlbum = fetchAlbumByName(albumName) {
            print("기존 앨범 '\(albumName)'을(를) 찾았습니다.")
            completion(true, existingAlbum, nil)
            return
        }
        
        print("새 앨범 '\(albumName)'을(를) 생성합니다.")
        
        // 2. 앨범이 없으면 생성 시도
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
    
    // 기존 앨범 이름으로 조회
    private func fetchAlbumByName(_ albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        // 사용자 생성 앨범 확인
        let userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: fetchOptions
        )
        
        if let album = userCollections.firstObject {
            return album
        }
        
        // 다른 앨범 유형도 확인
        let otherCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )
        
        return otherCollections.firstObject
    }
    
    // 새 앨범 생성
    private func createAlbum(named albumName: String, completion: @escaping (Bool, PHAssetCollection?, String?) -> Void) {
        // 중요: 동일한 이름의 앨범이 이미 존재하는지 다시 한번 확인
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
    
    // MARK: - 이미지 저장 함수들
    
    // 이미지를 특정 앨범에 저장
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
            // 앨범 저장 실패 시 기본 카메라롤에 저장 시도
            print("앨범에 저장 실패: \(error.localizedDescription)")
            saveImageToLibraryOnly(image, completion: completion)
        }
    }
    
    // 이미지를 카메라롤에만 저장
    private func saveImageToLibraryOnly(_ image: UIImage, completion: @escaping (Bool, String?) -> Void) {
        self.saveImageCompletion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 저장 콜백 저장 변수
    private var saveImageCompletion: ((Bool, String?) -> Void)?
    
    // 저장 완료 콜백
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            saveImageCompletion?(false, "이미지 저장 실패: \(error.localizedDescription)")
        } else {
            saveImageCompletion?(true, nil)
        }
        saveImageCompletion = nil
    }
    
    // MARK: - 이미지 전처리
    
    // 알파 채널 관련 문제 해결을 위한 이미지 처리
    private func processImageForSaving(_ image: UIImage) -> UIImage {
        // 알파 채널이 있는 이미지를 불투명 배경으로 변환
        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        // 먼저 흰색 배경 그리기
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: image.size))
        
        // 그 위에 이미지 그리기
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        // 새로운 불투명 이미지 반환
        return UIGraphicsGetImageFromCurrentImageContext() ?? image
    }
}
