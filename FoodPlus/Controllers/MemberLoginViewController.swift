//
//  LoginViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/23/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import Firebase

class MemberLoginViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
    }

    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    let alert = UIAlertController(
                    title: "Invalid Login",
                    message: "User Login failed: \(e.localizedDescription)",
                    preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let  result = self.db.collection(K.FStore.users).whereField(K.FStore.email, isEqualTo: email)
                    result.getDocuments { (querySnapshot, error) in
                        if let e = error{
                            print("Error: \(e)")
                        }else{
                            let userType = querySnapshot!.documents[0].data()[K.FStore.userType] as! String
                            if userType == K.FStore.member{
                                self.performSegue(withIdentifier: K.memberLogSeg, sender: self)
                            }else{
                                let alert = UIAlertController(
                                title: "Invalid Login",
                                message: "User Login failed: Please login using Restaurant Portal",
                                preferredStyle: UIAlertController.Style.alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    
                                }
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
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

