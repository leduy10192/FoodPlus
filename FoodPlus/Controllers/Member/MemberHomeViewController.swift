//
//  MemberHomeViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/29/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase

class MemberHomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var logoutButton = UIBarButtonItem(image: UIImage(named: "logout (2)"), style: .plain, target: self, action: #selector(logout))
    lazy var cartButton = BadgedButtonItem(with: UIImage(systemName: "cart"))
    lazy var orderBarButton = UIBarButtonItem(image: UIImage(named: "order"), style: .plain, target: self, action: #selector(viewOrder))

    let searchController = UISearchController(searchResultsController: nil)
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var items : [MemberItem] = []
    var cartItems : [MemberItem] = []
    var filteredItems: [MemberItem] = []

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    var selectedCellPath : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // SearchViewController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Foods"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["Name", "Place","City","Zip"]
        searchController.searchBar.delegate = self
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        navigationItem.setRightBarButtonItems([logoutButton, cartButton, orderBarButton], animated: false)
//       cartButton.setBadge(with: 10)
        cartButton.tapAction = {
            self.performSegue(withIdentifier: K.MhomeToMCart, sender: self)
        }

        collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        let leftAndRightPaddings: CGFloat = 20.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (view.frame.size.width - layout.minimumInteritemSpacing - leftAndRightPaddings)/2
        layout.itemSize = CGSize(width: width, height: 1.18*width)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        loadItems()
        loadCartItems()
    }
    
    func loadItems(){
        db.collectionGroup(K.FStore.orders).order(by: K.FStore.date, descending: true)
            .addSnapshotListener{ (querySnapshot, error) in
                self.activityIndicator.startAnimating()
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
                                let date = data[K.FStore.date] as? Double,
                                let resName = data[K.FStore.resName] as? String,
                                let street = data[K.FStore.street] as? String,
                                let city = data[K.FStore.city] as? String,
                                let state = data[K.FStore.state] as? String,
                                let zip = data[K.FStore.zip] as? String,
                                let phoneNumber = data[K.FStore.phoneNumber] as? String{
                                let newItem = MemberItem(name: itemName, email: email, uid: uid, price: price, quantity: quantity, unit: unit, isAvail: isAvail, imageURLString: imageUrlString, city: city, street: street, state: state, zip: zip, resName: resName, date: date, phoneNumber: phoneNumber)
                                self.items.append(newItem)
//                                print("MemberItem",self.items)
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func loadCartItems(){
        let email = (Auth.auth().currentUser?.email!)!
        db.collection(K.FStore.member).document(email).collection(K.FStore.cart)
            .order(by: K.FStore.date, descending: true)
            .addSnapshotListener{ (querySnapshot, error) in
                self.cartItems = []
                self.activityIndicator.startAnimating()
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
                                let date = data[K.FStore.date] as? Double,
                                let resName = data[K.FStore.resName] as? String,
                                let street = data[K.FStore.street] as? String,
                                let city = data[K.FStore.city] as? String,
                                let state = data[K.FStore.state] as? String,
                                let zip = data[K.FStore.zip] as? String,
                                let phoneNumber = data[K.FStore.phoneNumber] as? String{
                                let newItem = MemberItem(name: itemName, email: email, uid: uid, price: price, quantity: quantity, unit: unit, isAvail: isAvail, imageURLString: imageUrlString, city: city, street: street, state: state, zip: zip, resName: resName, date: date, phoneNumber: phoneNumber)
                                self.cartItems.append(newItem)
                                //                                print("MemberItem",self.items)
//                                DispatchQueue.main.async {
//                                    print(self.cartItems.count)
//                                    self.cartButton.setBadge(with: self.cartItems.count)
//                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            print(self.cartItems.count)
                            self.cartButton.setBadge(with: self.cartItems.count)
                        }
                    }
                }
        }
    }
    
     @objc func logout() {
        do {
          try Auth.auth().signOut()
            //navigate user to welcome screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func viewOrder() {
        print("NNNN")
        cartButton.setBadge(with: 5)
        
    }
    
    @objc func viewCart(){
        cartButton.tapAction = {
            print("RAP")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == K.MhomeToMCart {
            // remember to down cast it to the destination type (because default func doesn't know the new class type created)
            // cast! forced down cast
            let destinationVC = segue.destination as! CartViewController
                destinationVC.cartItems = cartItems
            
        }
    }

}
//MARK: - UICollectionViewDataSource
extension MemberHomeViewController: UICollectionViewDataSource{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if isFiltering {
              return filteredItems.count
            }
            return items.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
    //        cell.delegate = self
            let item: MemberItem
            if isFiltering {
              item = filteredItems[indexPath.row]
            } else {
              item = items[indexPath.row]
            }
            
//            if indexPath == selectedCellPath{
//                cell.cartIcon.image = UIImage(systemName: "cart.fill")
//            }
            cell.resNameLabel.text = item.resName
            cell.itemNameLabel.text = item.name
            if item.isAvail == false{
                cell.greenCircleLabel.alpha = 0.0
                cell.priceLabel.text = "Sold out"
            }else{
                cell.priceLabel.text = item.price
            }
            cell.quantityLabel.text = item.quantityUnit
            cell.dateLabel.text = item.dateString
            cell.locationLabel.text = item.location
            if let imageURL = item.imageURL{
                cell.postView.af.setImage(withURL: imageURL)
            }
            return cell
        }
}

//MARK: - UICollectionViewDelegate
extension MemberHomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellPath = indexPath
        let item: MemberItem
        if isFiltering {
          item = filteredItems[indexPath.row]
        } else {
          item = items[indexPath.row]
        }
        let alert = UIAlertController(title: "Add to Cart", message: "Do you want to add \(item.name) to your cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.activityIndicator.startAnimating()
            let email = (Auth.auth().currentUser?.email!)!
            let dataRef = self.db.collection(K.FStore.member).document(email).collection(K.FStore.cart).document(item.uid)
            let data = [
            K.FStore.uid: item.uid,
            K.FStore.imageUrl: item.imageURLString,
            K.FStore.email : item.email,
            K.FStore.isAvail: true,
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
            
            dataRef.setData(data, merge: true){ (error) in
                if let err = error {
                   print(err.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
//                self.cartButton.setBadge(with: self.cartItems.count )
                self.activityIndicator.stopAnimating()
//                self.collectionView.reloadData()
                }
            }

        }))

                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true)
    }
    
    func presentCartAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    
                    self.collectionView.reloadData()
        }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
    }
}

extension MemberHomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, scope: scope)
    }
    
     func filterContentForSearchText(_ searchText: String, scope: String){
      filteredItems = items.filter { (item: MemberItem) -> Bool in
        if scope == "Name"{
            return item.name.lowercased().contains(searchText.lowercased())
        }else if scope == "Place"{
            return item.resName.lowercased().contains(searchText.lowercased())
        }else if scope == "City"{
            return item.city.lowercased().contains(searchText.lowercased())
        }else {
            return item.zip.lowercased().contains(searchText.lowercased())
        }
      }
      
     collectionView.reloadData()
    }
    
}

extension MemberHomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

//extension MemberHomeViewController: AlertDelegate{
//    func presentAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true)
//        let email = (Auth.auth().currentUser?.email!)!
//        let dataReference = self.db.collection(K.FStore.member).document(email).collection(K.FStore.orders).document()
//                      let documentUid = dataReference.documentID
//    }
//}




