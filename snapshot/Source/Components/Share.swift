//
//  DetailView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/5/25.
//

import SwiftUI

struct Share: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel = ShareViewModel()
    let image: UIImage
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    print(image)
                    viewModel.share(stickerImage: image)
                } label: {
                    HStack(alignment: .center, spacing: 8){
                        Text("스토리에 공유하기")
                        Image(systemName: "square.and.arrow.up")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.main)
                    .roundedCorners(8, corners: [.allCorners])
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 24)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.grey(for: colorScheme))
        .navigationBarBackButtonHidden(true)
    }
}
