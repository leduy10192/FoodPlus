//
//  Item.swift
//  FoodPlus
//
//  Created by Duy Le on 4/28/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//
import Foundation

struct Item {
    let name: String
    let email: String
    let uid : String
    let price: String
    let quantity : String
    let unit : String
    let isAvail : Bool
    let imageURLString : String
    let city : String = ""
    let street: String = ""
    let state: String = ""
    let zip : String = ""
    let date : Double
    
//    init(name: String, email: String, uid: String, price: String, quantity: String, unit: String, isAvail: Bool, imageURL: String){
//        self.name = name
//        self.email = email
//        self.uid = uid
//        self.price = price
//        self.quantity = quantity
//        self.unit = unit
//        self.isAvail = isAvail
//        self.imageURL = imageURL
//    }
    var imageURL : URL?{
            return URL(string: imageURLString)
    }
    
    var dateString : String {
        let d = Date(timeIntervalSince1970: date)
        let formate = d.getFormattedDate(format: "MMM d, h:mm a")
        return formate
    }
    
    var quantityUnit : String {
        let quantityUnit = "\(quantity) \(unit)"
        return quantityUnit
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
