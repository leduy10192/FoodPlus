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
    let resName: String = ""
    let date : Double
    
        
    
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
    var price$ : String {
        return "$\(price)"
    }
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

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "y ago" : "\(interval)" + " " + "y ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "m ago" : "\(interval)" + " " + "m ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "d ago" : "\(interval)" + " " + "d ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "h ago" : "\(interval)" + " " + "h ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "min ago"
        }

        return "a moment ago"
    }
}
