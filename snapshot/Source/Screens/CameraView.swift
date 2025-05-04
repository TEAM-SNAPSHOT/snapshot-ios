//
//  CameraView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.colorScheme) var colorScheme
    private let frameList: [String] = ["1", "2", "3"]
    @State private var navigationTrigger = false
    
    var body: some View {
        VStack(spacing: 4){
            HStack{
                Spacer()
                Text("Frames")
                    .font(.primary(28))
                    .foregroundStyle(Color.black(for: colorScheme))
            }
            
            ScrollView {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 8)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: frameList.count), spacing: 12) {
                    ForEach(frameList, id: \.self) { frame in
                        Button {
                            UserDefaults.standard.set(frame, forKey: "selectedFrame")
                            navigationTrigger.toggle()
                        } label: {
                            Image("Frame \(frame)")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(2/3, contentMode: .fit)
                        }
                        
                    }
                }
                .padding(.bottom, 160)
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .navigationDestination(isPresented: $navigationTrigger) {
            ShotView()
        }
    }
}


#Preview {
    CameraView()
}
