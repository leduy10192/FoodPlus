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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let db = Firestore.firestore()
    
    var userType: String = K.FStore.restaurant
    
    override func viewDidLoad() {
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        print(userType)
    }

    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            userType = K.FStore.restaurant
        }else{
            userType = K.FStore.member
        }
        print(userType)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    print(e)
                }else{
                    self.db.collection(K.FStore.users).addDocument(data: [
                        K.FStore.email : email,
                        K.FStore.userType: self.userType
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
