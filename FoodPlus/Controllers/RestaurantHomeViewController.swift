//
//  RestaurantHomeViewController.swift
//  FoodPlus
//
//  Created by Duy Le on 4/24/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

class RestaurantHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 19{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddCell
            return cell
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! PostCell
            cell.nameLabel.text = "Pizza"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 19{
           self.performSegue(withIdentifier: "RHomeToRAdd", sender: self)
        }
    }
    
}
