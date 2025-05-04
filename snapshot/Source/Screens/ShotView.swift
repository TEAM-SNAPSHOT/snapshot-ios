//
//  ShotView.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//

import SwiftUI
import AVFoundation

struct ShotView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack {
                    Button {
                        viewModel.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button{
                        viewModel.capturePhoto()
                    } label: {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                            .frame(width: 80, height: 80)
                            .background(Circle().fill(Color.white))
                            .padding()
                    }
                    
                }
                .padding(.horizontal, 12)
            }
            
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(3/4, contentMode: .fit)
                    .border(Color.main, width: 2)
                Spacer()
            }
            .padding(.horizontal, 12)
            
            VStack{
                Text("네모에 맞춰서 사진을 찍어주세요!")
                    .foregroundStyle(Color(hex: "FFFFFF"))
                Spacer()
            }
            .padding(.top, 30)
            
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ShotView()
}
