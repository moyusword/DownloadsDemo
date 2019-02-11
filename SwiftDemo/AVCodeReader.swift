//
//  AVCodeReader.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/21.
//  Copyright © 2019 ML. All rights reserved.
//

import AVFoundation

class AVCodeReader: NSObject, CodeReader {
    
    private(set) var videoPreview = CALayer()
    private var captureSession: AVCaptureSession?
    private var completion: ((CodeReadResult) -> Void)?
    
    override init() {
        super.init()
        
        guard let captureVideoDevice = AVCaptureDevice.default(for: .video), let deviceInput = try? AVCaptureDeviceInput.init(device: captureVideoDevice) else {
            return
        }
        
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        //input
        captureSession.addInput(deviceInput)
        //output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.init(label: "com.chivalrous.li.SwiftDemo"))
        //interprets qr codes only
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        //preview
        let captureVideoPreview = AVCaptureVideoPreviewLayer.init(session: captureSession)
        captureVideoPreview.videoGravity = .resizeAspectFill
        self.videoPreview = captureVideoPreview
    }
    
    //MARK: -- delegate
    func startReading(completion: @escaping (CodeReadResult) -> Void) {
        guard let captureSession = captureSession else {
            completion(.failure(.noCameraAvailable))
            return
        }
        self.completion = completion
        captureSession.startRunning()
    }
    
    func stopReading() {
        captureSession?.stopRunning()
    }
}

extension AVCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let elemento = readableCode.stringValue else {
            return
        }
        
        completion?(.success(elemento))
    }
}
