//
//  Extensions.swift
//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//
import UIKit
import Photos

protocol AlertController{}
extension AlertController where Self:UIViewController {
    
    // ==========================================
    // ==========================================
    func presentSimpleAlert(title: String, message: String, completion: (() -> Void)?) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // UIAlertController must be presented by the calling controller (self)
        self.present(controller, animated: true, completion: completion)
    }
    
    // ==========================================
    // ==========================================
    func presentPhotoSelectionPrompt(completion: ((UIImagePickerControllerSourceType) -> Void)?) {
        
        let controller = UIAlertController(title: "Change Profile Picture", message: "Where do you want to take your picture?", preferredStyle: UIAlertControllerStyle.actionSheet)

        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            controller.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { _ in
 
                completion!(UIImagePickerControllerSourceType.camera)
            }))
        }
        
        controller.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { _ in
            completion!(UIImagePickerControllerSourceType.photoLibrary)
        }))
        
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(controller, animated: true, completion: nil)
        
    }
}

extension UIImage {
    
    // ==========================================
    // ==========================================
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // Create 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

extension UIImagePickerControllerDelegate {
    
    // ==========================================
    // ==========================================
    func convertImageToData(image: UIImage) -> Data? {
        return UIImageJPEGRepresentation(image, 0.8)
    }
}


extension UIViewController {
    
    // ==========================================
    // ==========================================
    func renderGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [Constants.Colors.primaryDark.cgColor, Constants.Colors.primaryLight.cgColor]
        return gradient
    }
}
