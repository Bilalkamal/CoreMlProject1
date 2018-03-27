//
//  ViewController.swift
//  CoreMlProject1
//
//  Created by Bilal on 2018-03-18.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        


    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
       if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            imageView.image = userPickedImage
        
        guard let ciImage = CIImage(image : userPickedImage) else {
            fatalError()
        }
        
        detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image : CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to Load CoreML Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError()
            }
            
            if let firstResult = results.first {
                var theResult = firstResult.identifier
                let delimiter = ","
                var token = theResult.components(separatedBy: delimiter)
                theResult = token[0]
                self.navigationItem.title = "This is a \(theResult)"
            }
            
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }catch {
            print(error)
        }
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        label.isHidden = true
    
    }
    


}

