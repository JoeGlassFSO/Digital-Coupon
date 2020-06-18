//
//  Merchant.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import Foundation

struct Merchant : Identifiable, Decodable{
    var id: String,
    
    city: String,
    offer: Int,
    cost: Int,
    state: String,
    street: String,
    zip: String,
    image: String,
    cuisine: String,
    name: String,
    rating: Int,
    hours: [Int]
    
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case city
        case offer
        case cost
        case state
        case street
        case zip
        case image
        case cuisine
        case name
        case rating
        case hours
    }
    
    init(id: String,
         city: String,
         offer: Int,
         cost: Int,
         state: String,
         street: String,
         zip: String,
         image: String,
         cuisine: String,
         name: String,
         rating: Int,
         hours: [Int]) throws {
        self.id = id
        self.city = city
        self.offer = offer
        self.rating = rating
        self.hours = hours
        self.cost = cost
        self.state = state
        self.name = name
        self.street = street
        self.zip = zip
        self.image = image
        self.cuisine = cuisine
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        city = try values.decode(String.self, forKey: .city)
        cost = try values.decode(Int.self, forKey: .cost)
        cuisine = try values.decode(String.self, forKey: .cuisine)
        hours = try values.decode([Int].self, forKey: .hours)
        image = try values.decode(String.self, forKey: .image)
        name = try values.decode(String.self, forKey: .name)
        offer = try values.decode(Int.self, forKey: .offer)
        rating = try values.decode(Int.self, forKey: .rating)
        state = try values.decode(String.self, forKey: .state)
        street = try values.decode(String.self, forKey: .street)
        zip = try values.decode(String.self, forKey: .zip)
    }
}
