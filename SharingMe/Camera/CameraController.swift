//
//  CameraController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/2/15.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController : UIViewController{
    
    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    let captureButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto(){
        print("capture photo")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupHUD()
    }
    
    fileprivate func setupHUD(){
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()

        //1.setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{return}
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }

        }catch let err{
            print("Could not setup camera input:", err)
        }

        //2.setup outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }

        //3.setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        view.layer.addSublayer(previewLayer)

        previewLayer.frame = view.frame
        captureSession.startRunning()
    }
}
