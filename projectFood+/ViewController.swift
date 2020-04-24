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

    
    var models = [Model]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
        
        cell.configure(with: models)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 214
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


