//
//  RegisterViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/23/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var signUpTop: NSLayoutConstraint!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    let db = Firestore.firestore()
    
    var userType: String = K.FStore.restaurant
    
    override func viewDidLoad() {
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        phoneTextField.setLeftPaddingPoints(50)
        streetField.setLeftPaddingPoints(10)
        cityField.setLeftPaddingPoints(10)
        stateField.setLeftPaddingPoints(10)
        zipField.setLeftPaddingPoints(10)
        print(userType)
    }

    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            userType = K.FStore.restaurant
            addressLabel.isHidden = false
            streetField.isHidden = false
            cityField.isHidden = false
            stateField.isHidden = false
            zipField.isHidden = false
            let duration: TimeInterval = 0.5
                 UIView.animate(withDuration: duration, animations: {
                    self.signUpTop.constant = 700
                           }, completion: nil)
        }else{
            userType = K.FStore.member
            addressLabel.isHidden = true
            streetField.isHidden = true
            cityField.isHidden = true
            stateField.isHidden = true
            zipField.isHidden = true
            let duration: TimeInterval = 0.5
             UIView.animate(withDuration: duration, animations: {
                self.signUpTop.constant = 350
                       }, completion: nil)
        }
        print(userType)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    print(e)
                }else{
                    self.db.collection(self.userType).document(email).setData([K.FStore.email : email])
                    self.db.collection(self.userType).document(email).collection("orders")
                        .addDocument(data: [
                        K.FStore.email : email,
                    ])
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}




extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
