//
//  ImageSlicer.swift
//  Tesseract
//
//  Created by Velichkin Nikita on 25/01/2019.
//

import UIKit
import Vision

class ImageSlicer: NSObject {
    private var image = UIImage()
    private var sliceCompletion: ((_ slices: [UIImage]) -> Void) = { _ in }
    
    private lazy var textDetectionRequest: VNDetectTextRectanglesRequest = {
        return VNDetectTextRectanglesRequest(completionHandler: self.handleDetectedText)
    }()
    
    func slice(image: UIImage, completion: @escaping ((_: [UIImage]) -> Void)) {
        self.image = image
        self.sliceCompletion = completion
        self.performVisionRequest(image: image.fixOrientationOfImage()!.cgImage!, orientation: .up)
    }
    
    private func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
                try imageRequestHandler.perform([self.textDetectionRequest])
            } catch let error as NSError {
                self.sliceCompletion([UIImage]())
                print("Failed to perform vision request: \(error)")
            }
        }
    }
    
    private func handleDetectedText(request: VNRequest?, error: Error?) {
        if let err = error as NSError? {
            print("Failed during detection: \(err.localizedDescription)")
            return
        }
        guard let results = request?.results as? [VNTextObservation], !results.isEmpty else { return }
        
        self.sliceImage(text: results, onImageWithBounds: CGRect(x: 0, y: 0, width: self.image.cgImage!.width, height: self.image.cgImage!.height))
    }
    
    private func sliceImage(text: [VNTextObservation], onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
        
        var slices = [UIImage]()
        
        for wordObservation in text {
            let wordBox = boundingBox(forRegionOfInterest: wordObservation.boundingBox, withinImageBounds: bounds)
            
            if !wordBox.isNull {
                guard let slice = self.image.cgImage?.cropping(to: wordBox) else { continue }
                slices.append(UIImage(cgImage: slice))
            }
        }
        
        self.sliceCompletion(slices)
        
        CATransaction.commit()
    }
    
    private func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        var rect = forRegionOfInterest
        
        rect.origin.x *= imageWidth - 2
        rect.origin.y = ((1 - rect.origin.y) * imageHeight) - (forRegionOfInterest.height * imageHeight) - 2
        
        rect.size.width *= imageWidth
        rect.size.width += 2
        rect.size.height *= imageHeight
        rect.size.height += 2
        
        return rect
    }
}
