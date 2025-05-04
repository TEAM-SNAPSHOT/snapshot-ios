//
//  Divider.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI

struct Divider: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 1)
    }
}

#Preview {
    Divider()
}
