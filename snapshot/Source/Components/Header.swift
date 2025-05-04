//
//  Header.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI

struct Header: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .bottom, spacing: 8){
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
                
                Text("SNAPSHOT")
                    .font(.primary(28))
                    .foregroundStyle(Color.brown(for: colorScheme))
                    .padding(.bottom, 2)
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: 64)
            
            Divider()
        }
            
        
    }
}

#Preview {
    Header()
}
