//
//  ViewController.swift
//  Tessarect
//
//  Created by Velichkin Nikita on 18/01/2019.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recognizedTextView: UITextView!
    @IBOutlet var recognizePicker: UIButton!
    @IBOutlet var imagePicker: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let indicator = SVProgressHUD.self
    var isImageChanged = false
    var recognizedText = ""
    var imagePickerVC = UIImagePickerController()
    var imageToRecognize : UIImage!
    var recognizer = Recognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        present(UIAlertController().imagePicker(context: self), animated: true)
    }
    
    @IBAction func recognizerButtonClickAction(_ sender: Any) {
        present(self.recognizerPicker(), animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        DispatchQueue.main.async {
            self.imageView.subviews.forEach({ (s) in
                s.removeFromSuperview()
            })
            
            DispatchQueue.main.async {
                self.indicator.setDefaultMaskType(.black)
                self.indicator.show(withStatus: "Preprocessing image...")
            }
            
            let fixedImage = (image.fixOrientationOfImage() ?? image)
            var preprocessedImage = fixedImage
            
            preprocessedImage = OpenCVWrapper.resize(preprocessedImage)
            preprocessedImage = OpenCVWrapper.grayscale(preprocessedImage)
            preprocessedImage = OpenCVWrapper.dilate(preprocessedImage)
            preprocessedImage = OpenCVWrapper.medianBlur(preprocessedImage)
            
            self.imageToRecognize = preprocessedImage
            self.imageView.image = fixedImage
            
            DispatchQueue.main.async {
                self.indicator.dismiss()
            }
        }
        self.isImageChanged = true
        dismiss(animated: true, completion: nil)
    }
    
    func recognizerPicker() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: "Choose recognizer", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Tesseract + OpenCV", style: .default, handler: { _ in
            self.recognize(with: .tesseract)
        }))
        alertController.addAction(UIAlertAction(title: "Tesseract + Vision", style: .default, handler: { _ in
            self.recognize(with: .slicer)
        }))
        alertController.addAction(UIAlertAction(title: "MLKit", style: .default, handler: { _ in
            self.recognize(with: .mlkit)
        }))
        
        return alertController
    }
    
    func recognize(with rec: Recognizers) {
        if isImageChanged {
            DispatchQueue.main.async {
                self.recognizedTextView.text = ""
                self.indicator.show(withStatus: "Recognizing...")
            }
            recognizer.recognize(type: rec, image: self.imageToRecognize, completion: { text in
                DispatchQueue.main.async {
                    self.recognizedTextView.text = text
                    self.indicator.dismiss()
                }
            })
        } else {
            present(UIAlertController().showErrorAlert(context: self, message: "No image selected.\nSelect image and try again!"), animated: true)
        }
    }
}
