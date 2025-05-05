//
//  CameraView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//

import SwiftUI
import SwiftUIMasonry

struct CameraView: View {
    @Environment(\.colorScheme) var colorScheme
    private let frameList: [String] = ["Horizontal1 Frame 1", "Horizontal1 Frame 2", "Horizontal1 Frame 3", "Horizontal1 Frame 4", "Horizontal1 Frame 5", "Horizontal1 Frame 6", "Horizontal1 Frame 7","Horizontal2 Frame 1", "Horizontal2 Frame 2", "Horizontal2 Frame 3", "Horizontal2 Frame 4", "Horizontal2 Frame 5", "Vertical Frame 1", "Vertical Frame 2", "Vertical Frame 3", "Vertical Frame 4", "Vertical Frame 5", "Vertical Frame 6"]
    @State private var navigationTrigger = false
    @State private var isConfirmed = false
    @StateObject private var photoStore = PhotoStore.shared
    @AppStorage("selectedFrame") var selectedFrame: String?
    
    
    var body: some View {
        if(photoStore.images.count == 8){
            VStack(spacing: 4){
                ScrollView {
                    HStack{
                        VStack(alignment: .leading, spacing: 4){
                            Text("Let's Make a SNAPSHOT!")
                                .font(.primary(20))
                                .foregroundStyle(Color.black(for: colorScheme))
                            Text("사진을 선택해주세요.")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.black(for: colorScheme))
                        }
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(photoStore.images, id: \.self) { image in
                            Button {
                                photoStore.toggleSelection(for: image)
                            } label: {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(3/4, contentMode: .fit)
                                        .overlay(
                                            photoStore.isSelected(image) ?
                                            RoundedRectangle(cornerRadius: 0)
                                                    .stroke(Color.main, lineWidth: 3)
                                            : nil
                                        )
                                        .clipped()

                                    if photoStore.isSelected(image) {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(Color.main)
                                                    .padding(6)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 200)
                }
                Spacer()
            }
            .padding(.top, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .overlay{
                VStack{
                    Spacer()
                    HStack{
                        Button{
                            photoStore.images.removeAll()
                            UserDefaults.standard.removeObject(forKey: "selectedFrames")
                        } label: {
                            HStack{
                                Text("다시 찍기")
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.gray)
                            .background(Color(hex: "F7F7F7"))
                            .roundedCorners(8, corners: [.allCorners])
                        }
                        if let selectedFrame = UserDefaults.standard.string(forKey: "selectedFrame"),
                            (selectedFrame.contains("Horizontal") &&
                            photoStore.selectedImages.count == 4) ||
                            (selectedFrame.contains("Vertical") &&
                            photoStore.selectedImages.count == 3) {
                            Button{
                                isConfirmed.toggle()
                            } label: {
                                HStack{
                                    Text("선택 완료!")
                                }
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color(hex: "FFFFFF"))
                                .background(Color.main)
                                .roundedCorners(8, corners: [.allCorners])
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 120)
                }
            }
            .navigationDestination(isPresented: $isConfirmed) {
                ResultView()
            }
            .onAppear{
                print(photoStore.images)
            }
        } else {
            VStack(spacing: 4){
                ScrollView {
                    HStack{
                        VStack(alignment: .leading, spacing: 4){
                            Text("Let's Take a SNAPSHOT!")
                                .font(.primary(20))
                                .foregroundStyle(Color.black(for: colorScheme))
                            Text("프레임을 선택해주세요.")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.black(for: colorScheme))
                        }
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    Masonry(.vertical, lines: 3, spacing: 4){
                        ForEach(frameList, id: \.self) { frame in
                            Button {
                                UserDefaults.standard.set(frame, forKey: "selectedFrame")
                                navigationTrigger.toggle()
                            } label: {
                                Image(frame)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.bottom, 160)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .navigationDestination(isPresented: $navigationTrigger) {
                ShotView()
            }
            .onAppear {
                print(photoStore.images)
            }
            
        }
    }
}


#Preview {
    CameraView()
}
