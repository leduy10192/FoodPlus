//
//  OrderConfirmViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 5/2/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

class OrderConfirmViewController: UIViewController {

    @IBOutlet weak var orderNumLabel: UILabel!
    
    var orderItems : [MemberItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myBackButton:UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        myBackButton.addTarget(self, action: #selector(popToRoot), for: UIControl.Event.touchUpInside)
        myBackButton.setTitle("Home", for: UIControl.State.normal)
        myBackButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
         self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        loadOrderNumber()
    }
    
    func loadOrderNumber(){
        var orderNumberString = ""
        for item in orderItems{
            if item.uid == orderItems.last?.uid{
                orderNumberString += "\(item.uid.suffix(5)) "
                break
            }
                orderNumberString += "\(item.uid.suffix(5)), "
        }
        orderNumLabel.text = orderNumberString
    }
    
    @objc func popToRoot() {
            performSegue(withIdentifier: K.OrderConfirmToHome, sender: self)
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
