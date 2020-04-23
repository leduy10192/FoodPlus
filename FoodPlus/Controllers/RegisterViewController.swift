//
//  RegisterViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/23/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        
    }

    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        let x =  segmentControl.titleForSegment(at: sender.selectedSegmentIndex)
        print(x)
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
