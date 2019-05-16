//
//  Recognizer.swift
//  Tesseract
//
//  Created by Velichkin Nikita on 02/04/2019.
//

import Foundation
import Vision
import Firebase

enum Recognizers {
    case tesseract
    case slicer
    case mlkit
}

class Recognizer: NSObject {
    func recognize(type: Recognizers, image: UIImage, completion: @escaping (_ text: String?) -> Void) {
        switch type {
        case .tesseract:
            
            let tesseractRecognizer = TesseractRecognizer()
            
            tesseractRecognizer.recognizeImageWithTesseract(image: image, completion: { text in
                completion(text)
            })
            
        case .slicer:
            
            let tesseractRecognizer = TesseractRecognizer()
            let imageSlicer = ImageSlicer()
            var outputText = ""
            var counter = 0
            imageSlicer.slice(image: image) { (images) in
                for img in images {
                    tesseractRecognizer.recognizeImageWithTesseract(image: img, completion: { text in
                        outputText += text?.replacingOccurrences(of: "\n\n", with: "\n") ?? "Nothing found"
                        
                        counter += 1
                        if (counter == images.count) {
                            completion(outputText)
                        }
                    })
                }
            }
            
        case .mlkit:
            
            let vision = Vision.vision()
            let textDetector = vision.onDeviceTextRecognizer()
            let visionImage = VisionImage(image: image)
            
            textDetector.process(visionImage, completion: { result, error in
                if error != nil {
                    completion(error?.localizedDescription)
                }
                completion(result?.text)
            })
        }
    }
}
