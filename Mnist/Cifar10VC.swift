//
//  Cifar10VC.swift
//  Mnist
//
//  Created by Melody on 4/14/18.
//  Copyright © 2018 Melody Yang. All rights reserved.
//

import UIKit
import Photos

class Cifar10VC: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var resultImage: UIImageView!
    
    @IBOutlet weak var classifyButton: UIButton!
    
    @IBAction func showButton(_ sender: Any) {
        let pixelBuffer = resultImage.image?._pixelBuffer(width: 32, height: 32)
        let model = cifar10()
        let output = try? model.prediction(image: pixelBuffer!)
        print(output?.classLabel)
        informResultPopUp(message: (output?.classLabel)!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        resultImage.addGestureRecognizer(tapGestureRecognizer)
        resultImage.isUserInteractionEnabled = true
        classifyButton.makeRounded()
        classifyButton.backgroundColor = UIColor.violetBlue
         classifyButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func informResultPopUp(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true) { () in
        }
    }
    
    @objc func tapImage(tapGestureRecognizer: UITapGestureRecognizer) {
        presentActionSheet()
    }
    
   func presentActionSheet() {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                self.openCamera()
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                self.openPhotoLibrary()
            })
            
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }

}

extension Cifar10VC: UINavigationControllerDelegate {
    
    func checkPermission(hanler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // Access is already granted by user
            hanler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // Access is granted by user
                    hanler()
                }
            }
        default:
            print("Error: no access to photo album.")
        }
    }
    
    func openPhotoLibrary() {
        checkPermission {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let jpegImage = UIImageJPEGRepresentation(image!, 0.3)
        picker.dismiss(animated: true)
        
        resultImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
    
}

