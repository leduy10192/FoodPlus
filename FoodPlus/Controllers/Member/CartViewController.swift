//
//  CartViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 5/1/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase
import Braintree

class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let db = Firestore.firestore()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var cartItems : [MemberItem] = []
    var deleteCartIndexPath: IndexPath? = nil
    var braintreeClient: BTAPIClient!
    var memberInfo : MemberInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        braintreeClient = BTAPIClient(authorization: "sandbox_7bzw92sx_bkmn4qbwpph22zxt")!
        
        //Eliminate extra separators below UITableView
        self.tableView.tableFooterView = UIView()
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: K.cartCell, bundle: nil), forCellReuseIdentifier: K.cartCell)
        updateTotalPriceUI()
        loadMemberInfo()
    }
    
    func loadMemberInfo(){
        activityIndicator.startAnimating()
        let email = (Auth.auth().currentUser?.email!)!
        db.collection(K.FStore.member).document(email).getDocument{ (snapShotDocument, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }else{
                if let document = snapShotDocument {
                    if  let memberName = document[K.FStore.name] as? String,
                        let memberPhoneNum = document[K.FStore.phoneNumber] as? String {
                        print(memberName, memberPhoneNum)
                        self.memberInfo = MemberInfo(memberName: memberName, memberEmail: email, memberPhoneNum: memberPhoneNum)
                         DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    func updateTotalPriceUI(){
        var subTotal = 0.0
        for price in cartItems {
            if let itemPrice = Double(price.price.dropFirst()){
                subTotal += itemPrice
            }
        }
        let tax = subTotal*0.0925
        let total = subTotal + tax
        subTotalLabel.text = String (format: "$%.2f", subTotal)
        taxLabel.text = String (format: "$%.2f", tax)
        totalPriceLabel.text = String (format: "$%.2f", total)
    }
    @IBAction func onCheckout(_ sender: Any) {
                activityIndicator.startAnimating()
                let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
                payPalDriver.viewControllerPresentingDelegate = self
                payPalDriver.appSwitchDelegate = self // Optional
                
                // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                
                let email = (Auth.auth().currentUser?.email!)!
                for item in self.cartItems{
                    //Update seller records, use seller email instead
                    let dataRef = self.db.collection(K.FStore.restaurant).document(item.email).collection(K.FStore.orders).document(item.uid)
                    dataRef.setData([
                        K.FStore.isAvail : false,
                        K.FStore.lastUpdated: FieldValue.serverTimestamp(),
                        K.FStore.memberName : self.memberInfo?.memberName ?? "",
                        K.FStore.memberPhoneNum : self.memberInfo?.memberPhoneNum ?? "",
                        K.FStore.memberEmail : email
                    ], merge: true) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        }
                    }
                    //put item into orders collection
                    let dataRef2 = self.db.collection(K.FStore.member).document(email).collection(K.FStore.memberOrders).document(item.uid)
                    let data = [
                        K.FStore.uid: item.uid,
                        K.FStore.imageUrl: item.imageURLString,
                        K.FStore.email : email,
                        K.FStore.isAvail: false,
                        K.FStore.itemName : item.name,
                        K.FStore.quantity : item.quantity,
                        K.FStore.unit : item.unit,
                        K.FStore.price : item.price,
                        K.FStore.date: Date().timeIntervalSince1970,
                        K.FStore.resName : item.resName,
                        K.FStore.phoneNumber : item.phoneNumber,
                        K.FStore.street : item.street,
                        K.FStore.city : item.city,
                        K.FStore.state : item.state,
                        K.FStore.zip : item.zip
                        ] as [String : Any]
                    
                    dataRef2.setData(data, merge: true){ (error) in
                        if let err = error {
                            print(err.localizedDescription)
                        }
                    }
                    //Delete Item in Cart
                    self.db.collection(K.FStore.member).document(email)
                        .collection(K.FStore.cart).document(item.uid).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                    }
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: K.CartToOrderConfirm, sender: self)
                }
                
            } else if let error = error {
                print(error)
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.CartToOrderConfirm {
            let destinationVC = segue.destination as! OrderConfirmViewController
            destinationVC.orderItems = cartItems
        }
    }
}

extension CartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cartItem", cartItems.count)
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cartCell, for: indexPath) as! CartCell
//        if indexPath.row >= cartItems.count - 1{
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
//        }
        let cartItem = cartItems[indexPath.row]
        if let imageURL = cartItem.imageURL{
            cell.postView.af.setImage(withURL: imageURL)
        }

        cell.FoodNameLabel.text = cartItem.name
        cell.priceLabel.text = cartItem.price
        cell.quantityLabel.text = cartItem.quantityUnit
        cell.locationLabel.text = cartItem.location
        cell.phoneLabel.text = cartItem.phoneNumber
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCartIndexPath = indexPath
            let cartItemToDelete = cartItems[indexPath.row]
            confirmDelete(cartItem: cartItemToDelete)
        }
    }
    
}

extension CartViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func confirmDelete(cartItem: MemberItem) {
        let alert = UIAlertController(title: "Remove Item(s) in Cart", message: "Are you sure you want to remove \(cartItem.name)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: handleDeleteCartItem)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteCartItem)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteCartItem(alertAction: UIAlertAction!) {
        if let indexPath = deleteCartIndexPath{
            
            //delete Cart Item in the db
            let email = (Auth.auth().currentUser?.email!)!
            let cartItemToDelete = cartItems[indexPath.row]
            db.collection(K.FStore.member).document(email)
                .collection(K.FStore.cart).document(cartItemToDelete.uid).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            tableView.beginUpdates()
            cartItems.remove(at: indexPath.row)
            //Note that indexPath is wrapped in an array: [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteCartIndexPath = nil
            tableView.endUpdates()
            //update FOOTER UI
            updateTotalPriceUI()
        }
    }
    
    func cancelDeleteCartItem(alertAction: UIAlertAction!){
        deleteCartIndexPath = nil
    }
}

extension CartViewController: BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
}
 
extension CartViewController: BTAppSwitchDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
}
