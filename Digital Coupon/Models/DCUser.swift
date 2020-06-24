//
//  UserView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import Foundation

struct DCUser {
    var id: String,
    
    name: String,
    city: String,
    state: String,
    street: String,
    dob: String,
    country: String,
    email: String,
    savings: Int,
    topSaves: [DCUserMerchants],
    topVisits: [DCUserMerchants]
    
}

struct DCUserMerchants : Identifiable, Decodable{
    var id: String,
    
    savings: Int,
    visits: Int,
    image: String,
    name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case visits
        case savings
        case image
        case name
    }
    
    init(id: String,
         visits: Int,
         savings: Int,
         image: String,
         name: String) throws {
        self.id = id
        self.savings = savings
        self.visits = visits
        self.name = name
        self.image = image
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        visits = try values.decode(Int.self, forKey: .visits)
        savings = try values.decode(Int.self, forKey: .savings)
        image = try values.decode(String.self, forKey: .image)
        name = try values.decode(String.self, forKey: .name)
    }
}

