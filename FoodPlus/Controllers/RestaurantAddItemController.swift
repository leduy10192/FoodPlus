//
//  RestaurantAddItemController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/25/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantAddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        //Check if the camera is avaiblabe, otherwise the app will crash{
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //if available, open up the camera
            picker.sourceType = .camera
            
            //if simulator, camera not available, use photo library
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        // This image is very large, Heroku has a limit of size image can upload -> import Alamofire and resize it
        let size = CGSize(width: 300, height: 300)
        
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        itemImageView.image = scaledImage
        
        //dismiss that camera viw
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
