//
//  RestaurantLoginViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/23/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

class RestaurantLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        // Do any additional setup after loading the view.
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
