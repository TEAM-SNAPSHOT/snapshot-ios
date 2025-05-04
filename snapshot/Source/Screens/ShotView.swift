//
//  ShotView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI

struct ShotView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedImage: UIImage?
    
    var body: some View {
        VStack{
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.grey(for: colorScheme))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ShotView()
}
