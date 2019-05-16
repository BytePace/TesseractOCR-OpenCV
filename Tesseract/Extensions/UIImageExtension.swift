//
//  UIImageExtension.swift
//  Tesseract
//
//  Created by Velichkin Nikita on 25/01/2019.
//

import UIKit

extension UIImage {
    
    func fixOrientationOfImage() -> UIImage? {
        
        guard imageOrientation != .up else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
