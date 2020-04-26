//
//  RestaurantAddItemController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/25/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class RestaurantAddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var unitLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    
    
    var imagePicker = UIImagePickerController()
    
    let db = Firestore.firestore()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()

    }
    
    @IBAction func onCameraButton(_ sender: Any) {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        // This image is very large, Heroku has a limit of size image can upload -> import Alamofire and resize it
        let size = CGSize(width: 300, height: 300)
        
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        itemImageView.image = scaledImage
        
        //dismiss that camera viw
        dismiss(animated: true, completion: nil)
        
    }
    

    
    @IBAction func onSubmit(_ sender: Any) {
        activityIndicator.startAnimating()
      
        guard let image = itemImageView.image, !(image.isEqual(UIImage(named: "image_placeholder"))),
            (itemImageView.image)!.pngData() != UIImage(named: "image_placeholder")?.pngData(),
            let data = image.jpegData(compressionQuality: 1.0),
            let itemName = itemNameLabel.text, itemName != "",
            let quantity = quantityLabel.text, quantity != "",
            let unit = unitLabel.text, unit != "",
            let price = priceLabel.text, price != ""
            else{
                presentAlert(title: "Error", message: "Some fields are missing.")
                return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(K.FStore.imagesFolder).child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    self.presentAlert(title: "Error", message: err.localizedDescription)
                    return
                }
                guard let url = url else {
                    self.presentAlert(title: "Error", message: "Something went wrong")
                    return
                }
                
                let email = (Auth.auth().currentUser?.email!)!
                let dataReference = self.db.collection(K.FStore.restaurant).document(email).collection(K.FStore.orders).document()
                let documentUid = dataReference.documentID
                
                let urlString = url.absoluteString
                let data = [
                    K.FStore.uid: documentUid,
                    K.FStore.imageUrl: urlString,
                    K.FStore.email : email,
                    K.FStore.isAvail: true,
                    K.FStore.itemName : itemName,
                    K.FStore.quanity : quantity,
                    K.FStore.unit : unit,
                    K.FStore.price : price,
                    K.FStore.date: Date().timeIntervalSince1970
                    ] as [String : Any]
                
                dataReference.setData(data) { (err) in
                    if let err = err {
                        self.presentAlert(title: "Error", message: err.localizedDescription)
                        return
                    }
                    UserDefaults.standard.set(documentUid, forKey: K.FStore.uid)
                    self.itemImageView.image = #imageLiteral(resourceName: "image_placeholder")
//                     self.presentAlert(title: "Sucessful", message: "Item has been posted")
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
    
    func presentAlert(title: String, message: String) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    @objc fileprivate func uploadPhoto(){
        
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


