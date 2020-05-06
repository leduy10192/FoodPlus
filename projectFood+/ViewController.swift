//
//  ViewController.swift
//  projectFood+
//
//  Created by Ge Ou on 2020/4/19.
//  Copyright © 2020 Ge Ou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var bigTable: UITableView!
    
    
    var models = [Model]()
//    var bigModels = [bigModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigTable.delegate = self
        bigTable.dataSource = self
        // Do any additional setup after loading the view.
        
        models.append(Model(text: "First", imageName: "Image-1", priceText: "$1"))
        models.append(Model(text: "Second", imageName: "Image-2", priceText: "Free"))
        models.append(Model(text: "Third", imageName: "Image-3", priceText: "$1"))
        models.append(Model(text: "Forth", imageName: "Image-4", priceText: "$2"))
        models.append(Model(text: "Damo", imageName: "Image-5", priceText: "$3"))
        
        models.append(Model(text: "First", imageName: "Image-1", priceText: "$1"))
        models.append(Model(text: "Second", imageName: "Image-2", priceText: "Free"))
        models.append(Model(text: "Third", imageName: "Image-3", priceText: "$1"))
        models.append(Model(text: "Forth", imageName: "Image-4", priceText: "$2"))
        models.append(Model(text: "Damo", imageName: "Image-5", priceText: "$3"))
        
        models.append(Model(text: "First", imageName: "Image-1", priceText: "$1"))
        models.append(Model(text: "Second", imageName: "Image-2", priceText: "Free"))
        models.append(Model(text: "Third", imageName: "Image-3", priceText: "$1"))
        models.append(Model(text: "Forth", imageName: "Image-4", priceText: "$2"))
        models.append(Model(text: "Damo", imageName: "Image-5", priceText: "$3"))
        
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        
      
    }
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table{
            let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
            cell.configure(with: models)
            return cell
        } else if tableView == bigTable{
            let cell = bigTable.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == table{
            return 214
        } else if tableView == bigTable{
            return 330
        }
        return CGFloat()
    }

}

struct Model {
    let text: String
    let imageName: String
    let priceText: String
    
    init(text: String, imageName: String, priceText: String) {
        self.text = text
        self.imageName = imageName
        self.priceText = priceText
    }
}

//struct bigModel {
//    let store: String
//    let address: String
//    let price: String
//    let image: String
//    let name: String
//    let postTime: String
//
//    init(store: String, address: String, price: String, image: String, name: String, postTime: String) {
//        self.store = store
//        self.address = address
//        self.price = price
//        self.image = image
//        self.name = name
//        self.postTime = postTime
//    }
//}

