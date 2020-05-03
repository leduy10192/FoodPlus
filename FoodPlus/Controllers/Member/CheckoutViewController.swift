//
//  CheckoutViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 5/2/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import Braintree

class CheckoutViewController: UIViewController {
    
    var braintreeClient: BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        braintreeClient = BTAPIClient(authorization: "sandbox_7bzw92sx_bkmn4qbwpph22zxt")!
        
    }
    
    @IBAction func PayPalClicked(_ sender: Any) {
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
//        payPalDriver.viewControllerPresentingDelegate = self
//        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
//                let email = tokenizedPayPalAccount.email
//                let firstName = tokenizedPayPalAccount.firstName
//                let lastName = tokenizedPayPalAccount.lastName
//                let phone = tokenizedPayPalAccount.phone
//
//                // See BTPostalAddress.h for details
//                let billingAddress = tokenizedPayPalAccount.billingAddress
//                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                
            } else if let error = error {
                print(error)
            } else {
                // Buyer canceled payment approval
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

//extension CheckoutViewController: BTViewControllerPresentingDelegate {
//    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
//
//    }
//
//    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
//
//    }
//
//}
//
//extension CheckoutViewController: BTAppSwitchDelegate{
//    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
//
//    }
//
//    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
//
//    }
//
//    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
//
//    }
//}
