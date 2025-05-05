//
//  Capture.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI

public extension View {
  @MainActor
  func captureView(
    of view: some View,
    scale: CGFloat = 4.0,
    size: CGSize? = nil,
    completion: @escaping (UIImage?) -> Void
  ) {
    let renderer = ImageRenderer(content: view)
    renderer.scale = scale
    
    if let size = size {
      renderer.proposedSize = .init(size)
    }
    
    completion(renderer.uiImage)
  }
}
