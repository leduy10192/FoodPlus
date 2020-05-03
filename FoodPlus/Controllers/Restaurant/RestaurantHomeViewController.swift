//
//  RestaurantHomeViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/24/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import Firebase
import TinyConstraints
import AlamofireImage

class RestaurantHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resAddrLabel: UILabel!
    @IBOutlet weak var resPhoneLabel: UILabel!

    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var items : [Item] = []
    
    var resInfo : ResInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier)
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "AddCell", bundle: nil), forCellWithReuseIdentifier: "AddCell")
        
        let leftAndRightPaddings: CGFloat = 20.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (view.frame.size.width - layout.minimumInteritemSpacing - leftAndRightPaddings)/2
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        
        loadResInfo()
        loadItems()
    }
    
    func loadResInfo(){
        let email = (Auth.auth().currentUser?.email!)!
        db.collection(K.FStore.restaurant).document(email).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }else{
                if let snapshotDocument = querySnapshot{
                    if  let resName = snapshotDocument[K.FStore.name] as? String,
                        let resStreet = snapshotDocument[K.FStore.street] as? String,
                        let resCity = snapshotDocument[K.FStore.city] as? String,
                        let resState = snapshotDocument[K.FStore.state] as? String,
                        let resZip = snapshotDocument[K.FStore.zip] as? String,
                        let resPhone = snapshotDocument[K.FStore.phoneNumber] as? String{
                        self.resInfo = ResInfo(name: resName, phoneNumber: resPhone, street: resStreet, state: resState, city: resCity, zip: resZip)
                        DispatchQueue.main.async {
                            self.resNameLabel.text = self.resInfo?.name
                            self.resAddrLabel.text = self.resInfo?.address
                            self.resPhoneLabel.text = self.resInfo?.phoneNumber
                        }
                }
            }
        }
    }
}
    
    func loadItems(){
        let email = (Auth.auth().currentUser?.email!)!
        activityIndicator.startAnimating()
        db.collection(K.FStore.restaurant).document(email).collection(K.FStore.orders)
            .order(by: K.FStore.date)
            .addSnapshotListener{ (querySnapshot, error) in
            self.items = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[K.FStore.uid] as? String,
                            let imageUrlString = data[K.FStore.imageUrl] as? String,
                            let email = data[K.FStore.email] as? String,
                            let isAvail = data[K.FStore.isAvail] as? Bool,
                            let itemName = data[K.FStore.itemName] as? String,
                            let quantity = data[K.FStore.quantity] as? String,
                            let unit = data[K.FStore.unit] as? String,
                            let price = data[K.FStore.price] as? String,
                            let date = data[K.FStore.date] as? Double{
                            let newItem = Item(name: itemName, email: email, uid: uid, price: price, quantity: quantity, unit: unit, isAvail: isAvail, imageURLString: imageUrlString, date: date)
                            self.items.append(newItem)
                            print("Data",data)
                            print("ITEMS",self.items)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.activityIndicator.stopAnimating()
                            }
                        }
                       
                    
//                        if let messageSender = data[K.FStore.] as? String,
//                            let messageBody = data[K.FStore.bodyField] as? String {
//                            let newMessage = Message(sender: messageSender, body: messageBody)
//                            self.messages.append(newMessage)
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
                    }
                }
            }
        }
    }
    @IBAction func logout(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            //navigate user to welcome screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func editResInfoPressed(_ sender: UIButton) {
        let email = (Auth.auth().currentUser?.email!)!
        db.collection(K.FStore.restaurant).document(email).setData([K.FStore.city : "San Mateo"], merge: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return items.count+1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == items.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddCell
            
            return cell
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! PostCell
            cell.nameLabel.text = items[indexPath.row].name
            if(items[indexPath.row].isAvail == false){
                cell.priceLabel.text = "Sold out"
                cell.greenCircle.alpha = 0.0
            }else{
                cell.priceLabel.text = items[indexPath.row].price
            }
            cell.quantityLabel.text = items[indexPath.row].quantityUnit
            cell.dateLabel.text = items[indexPath.row].dateString
            if let imageURL = items[indexPath.row].imageURL{
                cell.postImage.af.setImage(withURL: imageURL)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == items.count {
           self.performSegue(withIdentifier: "RHomeToRAdd", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "RHomeToRAdd" {
            // remember to down cast it to the destination type (because default func doesn't know the new class type created)
            // cast! forced down cast
            let destinationVC = segue.destination as! RestaurantAddItemController
                destinationVC.resInfo = self.resInfo
            
        }
    }
    
}
