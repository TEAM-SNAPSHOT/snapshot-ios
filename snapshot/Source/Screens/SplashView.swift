//
//  SplashView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Image("Logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 200)
            Text("SNAPSHOT")
                .font(.primary(32))
                .foregroundStyle(Color.brown)
            Spacer()
            Text("© 2025 Snapshot All rights reserved.")
                .font(.system(size: 12))
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.main)
        .foregroundStyle(Color.grey)
    }
}

#Preview {
    SplashView()
}
