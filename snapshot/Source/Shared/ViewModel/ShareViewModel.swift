//
//  ShareViewModel.swift
//  snapshot
//
//  Created by cher1shRXD on 5/5/25.
//

import Foundation
import UIKit

class ShareViewModel: ObservableObject {
    func share(stickerImage: UIImage) {
        ShareViewModel.shareBackgroundAndStickerImage(stickerImage: stickerImage)
    }
    
    static func shareBackgroundAndStickerImage(stickerImage: UIImage?) {
        
        guard let backgroundImage = UIImage(named: "StoryBg")?.pngData(),
              let stickerImage = stickerImage?.pngData() else { return }

        shareToInstagram(pasteboardItems: [
            "com.instagram.sharedSticker.backgroundImage": backgroundImage,
            "com.instagram.sharedSticker.stickerImage": stickerImage
        ])
    }

    private static func shareToInstagram(pasteboardItems: [String: Any]) {
        guard let urlScheme = URL(string: "instagram-stories://share?source_application=\(appId)"),
              UIApplication.shared.canOpenURL(urlScheme) else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/instagram/id389801252")!, options: [:], completionHandler: nil)
            return
        }

        let items = [pasteboardItems]
        let options: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]

        UIPasteboard.general.setItems(items, options: options)
        UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
    }
    
    private static var appId: String {
        guard let appId = Bundle.main.object(forInfoDictionaryKey: "META_APP_ID") as? String else {
            print("no app id")
            fatalError("META_APP_ID not found in Info.plist")
        }
        return appId
    }
}
