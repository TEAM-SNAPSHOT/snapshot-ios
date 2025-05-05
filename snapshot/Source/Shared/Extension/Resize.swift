//
//  Resize.swift
//  snapshot
//
//  Created by cher1shRXD on 5/5/25.
//

import SwiftUI

extension Image {
    func resize(targetSize: CGSize, opaque: Bool = false) -> Image? {
        guard let uiImage = self.toUIImage() else { return nil }
        guard let resizedUIImage = uiImage.resize(targetSize: targetSize, opaque: opaque) else { return nil }
        return Image(uiImage: resizedUIImage)
    }
    
    private func toUIImage() -> UIImage? {
        // Image에서 UIImage로 변환
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        // UIHostingController의 view에서 이미지 추출
        let targetSize = CGSize(width: 1, height: 1)  // 사이즈는 적당히 설정
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        let img = renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
        }
        
        return img
    }
}

extension UIImage {
    func resize(targetSize: CGSize, opaque: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, opaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        draw(in: newRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
