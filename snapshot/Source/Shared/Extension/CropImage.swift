//
//  Untitled.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import UIKit

extension CameraViewModel {
    // 이미지를 3:4 비율로 가운데에서 크롭하는 함수
    func cropImageToAspectRatio(_ image: UIImage, ratio: CGFloat = 3.0/4.0) -> UIImage {
        // 원본 이미지 크기
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        
        // 원본 이미지의 비율
        let originalRatio = originalWidth / originalHeight
        
        // 결과 이미지의 크기 계산
        var resultWidth: CGFloat
        var resultHeight: CGFloat
        
        if originalRatio > ratio {
            // 원본이 더 넓은 경우, 높이를 기준으로 너비 계산
            resultHeight = originalHeight
            resultWidth = originalHeight * ratio
        } else {
            // 원본이 더 좁은 경우, 너비를 기준으로 높이 계산
            resultWidth = originalWidth
            resultHeight = originalWidth / ratio
        }
        
        // 크롭할 영역의 원점(중앙 기준) 계산
        let x = (originalWidth - resultWidth) / 2
        let y = (originalHeight - resultHeight) / 2
        
        // 크롭할 영역 정의
        let cropRect = CGRect(x: x, y: y, width: resultWidth, height: resultHeight)
        
        // 이미지 좌표계 변환을 위한 준비
        // UIKit과 Core Graphics의 좌표계가 다름 (UIKit은 좌상단 원점, Core Graphics는 좌하단 원점)
        let cgImage = image.cgImage!
        
        // 이미지 크롭
        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            // UIImage로 변환하여 반환 (원본 이미지의 scale과 orientation 유지)
            return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        }
        
        // 크롭 실패 시 원본 반환
        return image
    }
}
