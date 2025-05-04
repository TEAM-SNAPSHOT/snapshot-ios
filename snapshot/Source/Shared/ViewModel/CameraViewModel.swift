//
//  CameraViewModel.swift
//  snapshot
//
//  Created by cher1shRXD on 5/4/25.
//
import Foundation
import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImages: [UIImage] = []
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var isFrontCamera = false
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    self.showPermissionsAlert()
                }
            }
        default:
            showPermissionsAlert()
        }
    }
    
    private func showPermissionsAlert() {
        DispatchQueue.main.async {
            self.alertTitle = "카메라 권한 필요"
            self.alertMessage = "설정에서 카메라 권한을 허용해주세요."
            self.showAlert = true
        }
    }
    
    func setupSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.beginConfiguration()
            
            if self.session.canSetSessionPreset(.photo) {
                self.session.sessionPreset = .photo
            }
            
            self.setupDevice()
            
            self.setupInputs()
            
            self.setupOutput()
            
            self.session.commitConfiguration()
            
            self.session.startRunning()
        }
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: isFrontCamera ? .front : .back
        )
        
        if let device = deviceDiscoverySession.devices.first {
            camera = device
        } else {
            showSetupError()
        }
    }
    
    private func setupInputs() {
        guard let camera = camera else { return }
        
        do {
            session.inputs.forEach { session.removeInput($0) }
            
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                showSetupError()
            }
        } catch {
            showSetupError()
        }
    }
    
    private func setupOutput() {
        session.outputs.forEach { session.removeOutput($0) }
        
        let output = AVCapturePhotoOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            photoOutput = output
        } else {
            showSetupError()
        }
    }
    
    private func showSetupError() {
        DispatchQueue.main.async {
            self.alertTitle = "카메라 설정 오류"
            self.alertMessage = "카메라를 설정할 수 없습니다."
            self.showAlert = true
        }
    }
    
    func switchCamera() {
        isFrontCamera.toggle()
        setupSession()
    }
    
    func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func stopSession() {
        session.stopRunning()
    }
    
    func savePhoto(_ image: UIImage) {
        print("사진 저장 로직 실행")
        
//        capturedImage = nil
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("사진 촬영 오류: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        let croppedImage = cropImageToAspectRatio(image, ratio: 3.0/4.0)
            
        DispatchQueue.main.async {
            self.capturedImages.append(croppedImage)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
