//
//  QRScannerConfirmVC.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerConfirmVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var topbar: UIView!
    @IBOutlet var bottombar: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    var isDetected: Bool = false
    var amount: Int = 20
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                        AVMetadataObjectTypeCode39Code,
                        AVMetadataObjectTypeCode39Mod43Code,
                        AVMetadataObjectTypeCode93Code,
                        AVMetadataObjectTypeCode128Code,
                        AVMetadataObjectTypeEAN8Code,
                        AVMetadataObjectTypeEAN13Code,
                        AVMetadataObjectTypeAztecCode,
                        AVMetadataObjectTypePDF417Code,
                        AVMetadataObjectTypeQRCode]
    
     func getTravelTimeString() -> (Int,Int) {
        
        let timeInSeconds = UserDefaults.standard.object(forKey: "startTime") as! Int
            UserDefaults.standard.removeObject(forKey: "startTime")
           
            let (h, m, _) = (timeInSeconds / 3600, (timeInSeconds % 3600) / 60, (timeInSeconds % 3600) % 60)
            return (h,m)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PaymentVC" {
            
            if let vc = segue.destination as? PaymentVC{
                
                vc.amount = amount
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (hour, minute) = getTravelTimeString()
        if hour > 0 && minute > 0{
            
            self.timeLbl.text = String("\(hour)hr\(minute) min")
            self.amountLbl.text = String(hour * amount)
        }
        else if minute > 0{
            
            self.timeLbl.text = String("\(minute) min")
            self.amountLbl.text = String(amount)
        }
        else{
            self.timeLbl.text = String("2 min")
            self.amountLbl.text = String(amount)
        }
        
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: bottombar)
            view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            isDetected = false
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue == "parkingZone1"  && isDetected != true {
                isDetected = true
                self.performSegue(withIdentifier: "PaymentVC", sender: self)
            }
        }
    }

}
