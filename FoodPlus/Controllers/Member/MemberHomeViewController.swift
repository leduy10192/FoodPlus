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

class MemberHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var items : [MemberItem] = []
    var filteredItems: [MemberItem] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }


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
        
        collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        let leftAndRightPaddings: CGFloat = 20.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (view.frame.size.width - layout.minimumInteritemSpacing - leftAndRightPaddings)/2
        layout.itemSize = CGSize(width: width, height: 1.18*width)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        loadItems()
    }
    
    func loadItems(){
        db.collectionGroup(K.FStore.orders).order(by: K.FStore.date, descending: true)
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
                                let date = data[K.FStore.date] as? Double,
                                let resName = data[K.FStore.resName] as? String,
                                let street = data[K.FStore.street] as? String,
                                let city = data[K.FStore.city] as? String,
                                let state = data[K.FStore.state] as? String,
                                let zip = data[K.FStore.zip] as? String{
                                let newItem = MemberItem(name: itemName, email: email, uid: uid, price: price, quantity: quantity, unit: unit, isAvail: isAvail, imageURLString: imageUrlString, city: city, street: street, state: state, zip: zip, resName: resName, date: date)
                                self.items.append(newItem)
                                print("MemberItem",self.items)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
          return filteredItems.count
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item: MemberItem
        if isFiltering {
          item = filteredItems[indexPath.row]
        } else {
          item = items[indexPath.row]
        }
        cell.resNameLabel.text = item.resName
        cell.itemNameLabel.text = item.name
        cell.priceLabel.text = item.price
        cell.quantityLabel.text = item.quantityUnit
        cell.dateLabel.text = item.dateString
        cell.locationLabel.text = item.location
        if let imageURL = item.imageURL{
            cell.postView.af.setImage(withURL: imageURL)
        }
        return cell
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
