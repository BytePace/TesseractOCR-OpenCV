//
//  TesseractRecognizer.swift
//  Tesseract
//
//  Created by Velichkin Nikita on 25/01/2019.
//

import UIKit
import SVProgressHUD
import TesseractOCRSDKiOS

class TesseractRecognizer: NSObject  {
    func recognizeImageWithTesseract(image: UIImage, completion: @escaping (_ text: String?) -> Void) {
        
        guard let tesseract = MGTesseract(language: "rus+eng") else { return }
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .singleBlock
        tesseract.delegate = self
        tesseract.charBlacklist = "^&{}<>;`'"
        tesseract.image = image
        tesseract.recognize()
        completion(tesseract.recognizedText)
    }
    
}

extension TesseractRecognizer : MGTesseractDelegate {
    func progressImageRecognition(for tesseract: MGTesseract) {
        print("Progress: \(tesseract.progress)%")
    }
}
