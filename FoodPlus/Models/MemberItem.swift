//
//  Item.swift
//  FoodPlus
//
//  Created by Duy Le on 4/28/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//
import Foundation

struct MemberItem {
    let name: String
    let email: String
    let uid : String
    let price: String
    let quantity : String
    let unit : String
    let isAvail : Bool
    let imageURLString : String
    let city : String
    let street: String
    let state: String
    let zip : String
    let resName: String
    let date : Double
    let phoneNumber : String
        
    
//    init(name: String, email: String, uid: String, price: String, quantity: String, unit: String, isAvail: Bool, imageURLString: String, resName: String, date: Double){
//        self.name = name
//        self.email = email
//        self.uid = uid
//        self.price = price
//        self.quantity = quantity
//        self.unit = unit
//        self.isAvail = isAvail
//        self.imageURLString = imageURLString
//        self.date = date
//        self.resName = resName
//    }
    var location : String {
        let loc = "\(city), \(state) \(zip)"
        return loc
    }
    
    var imageURL : URL?{
            return URL(string: imageURLString)
    }
    
    var dateString : String {
        let d = Date(timeIntervalSince1970: date)
        return d.timeAgoSinceDate()
    }
    
    var quantityUnit : String {
        let quantityUnit = "\(quantity) \(unit)"
        return quantityUnit
    }
}
