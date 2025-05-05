//
//  PhotoStore.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//
import Foundation
import SwiftUI

class PhotoStore: ObservableObject {
    static let shared = PhotoStore()
    @Published var images: [UIImage] = []
    @Published var selectedImages: [UIImage] = []

    func toggleSelection(for image: UIImage) {
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        } else {
            if let selectedFrame = UserDefaults.standard.string(forKey: "selectedFrame") {
                if selectedFrame.contains("Vertical") {
                    if selectedImages.count < 3 {
                        selectedImages.append(image)
                    }
                } else {
                    if selectedImages.count < 4 {
                        selectedImages.append(image)
                    }
                }
            }
            
        }
    }

    func isSelected(_ image: UIImage) -> Bool {
        return selectedImages.contains(image)
    }
    
    private init() {}
}
