//
//  ResInfo.swift
//  FoodPlus
//
//  Created by Duy Le on 4/28/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import Foundation

struct ResInfo {
    let name: String
    let phoneNumber : String
    let street : String
    let state : String
    let city : String
    let zip : String
    
    var address : String {
        let addr = "\(street) \(city), \(state) \(zip)"
        return addr
    }
    
}
