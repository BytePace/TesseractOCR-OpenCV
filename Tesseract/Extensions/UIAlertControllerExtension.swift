//
//  UIAlertControllerExtension.swift
//  Tesseract
//
//  Created by Velichkin Nikita on 02/04/2019.
//
extension UIAlertController {
    func imagePicker(context: UIViewController) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.showPickerController(with: .camera, context: context)
        }))
        alertController.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
            self.showPickerController(with: .photoLibrary, context: context)
        }))
        return alertController
    }
    
    func showErrorAlert(context: UIViewController, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
    }
    
    func showPickerController(with type: UIImagePickerController.SourceType, context: UIViewController) {
        let imagePickerVC = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            imagePickerVC.sourceType = type
            imagePickerVC.delegate = context as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            context.present(imagePickerVC, animated: true, completion: nil)
        }
    }
}
