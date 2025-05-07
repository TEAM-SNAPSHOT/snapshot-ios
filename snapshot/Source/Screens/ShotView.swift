//
//  ShotView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI
import AVFoundation

struct ShotView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CameraViewModel()
    @State private var isShowingImagePicker: Bool = false
    @StateObject private var photoStore = PhotoStore.shared
    @AppStorage("tutorial") private var tutorialShown: Bool = false
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.showSplash {
                Color.white
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            
            VStack{
                HStack(spacing: 4){
                    
                    Spacer()
                    if viewModel.isCapturing {
                        Text("\(viewModel.countdown)")
                            .font(.title2)
                            .foregroundColor(.white)
                        Image(systemName: "timer")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .zIndex(1)
            
            VStack {
                Spacer()
                HStack {
                    Button {
                        dismiss()
                        photoStore.images.removeAll()
                    } label: {
                        Image(systemName: "iphone.and.arrow.forward.outward")
                            .font(.title)
                            .foregroundStyle(.red)
                            .rotationEffect(.init(degrees: 180))
                    }
                    .frame(width: 56, height: 56)
                    
                    
                    
                    Spacer()
                    
                    VStack {
                        Button {
                            viewModel.startTimedCapture()
                        } label: {
                            HStack(spacing: 0){
                                if !viewModel.isCapturing {
                                    Text("GO!")
                                        .font(.primary(20))
                                } else{
                                    Text("8/")
                                    Text("\(viewModel.remainingShots)")
                                }
                                
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 24, height: 2)
                                
                                Image("Logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 44)
                                    
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.main)
                            .foregroundStyle(.white)
                            .roundedCorners(16, corners: [.allCorners])
                            
                        }
                        .disabled(viewModel.shootDisabled)

                    }
                    
                    Spacer()
                    
                    
                    Button {
                        viewModel.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(width: 56, height: 56)
                    
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            
            if !tutorialShown {
                Tutorial()
            }
            
        }
        .onAppear {
            viewModel.checkPermissions()
            viewModel.setupSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
        .onChange(of: viewModel.isRemainingShotsZero) { newValue in
            if newValue {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ShotView()
}
