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
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var countdown: Int = 0
    @Published var remainingShots: Int = 8
    @Published var isRemainingShotsZero: Bool = false
    @Published var showSplash = false
    @Published var isCapturing = false
    @Published var shootDisabled: Bool = false

    private var timer: Timer?
    private var isCapturingPhoto = false

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
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    private func setupDevice() {
        let devices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: isFrontCamera ? .front : .back
        ).devices

        guard let device = devices.first else {
            showSetupError()
            return
        }

        camera = device
        do {
            try device.lockForConfiguration()
            let zoomFactor: CGFloat = 2
            if zoomFactor <= device.activeFormat.videoMaxZoomFactor {
                device.videoZoomFactor = zoomFactor
            }
            device.unlockForConfiguration()
        } catch {
            print("카메라 줌 설정 오류: \(error.localizedDescription)")
        }
    }

    private func setupInputs() {
        guard let camera = camera else { return }
        session.inputs.forEach { session.removeInput($0) }

        do {
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

    func stopSession() {
        session.stopRunning()
    }

    func capturePhotoWithSplash() {
        guard !isCapturingPhoto else { return }
        isCapturingPhoto = true

        showSplash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.capturePhoto()
            self.showSplash = false
        }
    }

    func capturePhoto() {
        guard let photoOutput = photoOutput else {
            isCapturingPhoto = false
            return
        }

        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func startTimedCapture() {
        let interval = Int(UserDefaults.standard.string(forKey: "shotCount") ?? "8") ?? 8
        countdown = interval

        if isCapturing {
            takePhoto()
            shootTemporarilyDisabled()
            return
        }

        isCapturing = true
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.countdown -= 1

            if self.countdown == 0 {
                self.takePhoto()
                self.shootTemporarilyDisabled()
            }
        }
    }

    private func shootTemporarilyDisabled() {
        DispatchQueue.main.async {
            self.shootDisabled = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shootDisabled = false
        }
    }

    private func takePhoto() {
        let interval = Int(UserDefaults.standard.string(forKey: "shotCount") ?? "8") ?? 8
        countdown = interval

        capturePhotoWithSplash()
        remainingShots -= 1

        if remainingShots <= 0 {
            timer?.invalidate()
            timer = nil
            isCapturing = false
            isRemainingShotsZero.toggle()
        } else {
            countdown = interval
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        defer { isCapturingPhoto = false }

        guard error == nil,
              let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }

        var processedImage = image
        if isFrontCamera {
            processedImage = normalizeImage(image)
        }

        DispatchQueue.main.async {
            PhotoStore.shared.images.append(processedImage)
        }
    }

    private func normalizeImage(_ image: UIImage) -> UIImage {
        if let cgImage = image.cgImage {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
        }
        return image
    }
}
