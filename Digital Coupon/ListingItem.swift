//
//  ListingItem.swift
//  Digital Coupon
//
//  Created by Mac on 18/06/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

let frameHeight: CGFloat = 240
let bottomOffset: CGFloat = -103
let cornerRad: CGFloat = 25
let x: CGFloat = 0

struct ListingItem: View {
    
    let frameSize: CGFloat = 95
    var merchant: Merchant
    
    @State var price: String = ""
    @ObservedObject var session = FirebaseSession()
    
    var body: some View {
        
            HStack {
                Image("")
                    .resizable()
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.2))
                    .shadow(radius: 10)
                    .padding()
                    .frame(width: frameSize, height: frameSize)
                
                VStack(alignment: .leading){
                    
                    Text(merchant.name)
                    .font(.footnote)
                        .fontWeight(.bold)
                    
                    Text(merchant.street)
                        .font(.footnote)
                    
                    Text(price)
                        .font(.footnote)
                    
                }.onAppear(perform: formatPrice)
                
                Spacer()
                VStack(alignment: .trailing){
                    
                    Text(merchant.cuisine)
                        .font(.footnote)
                    HStack{
                        ForEach (0..<merchant.rating) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                        }
                    }
                    
                }
                
                
            }
            .foregroundColor(.blue)
    }
    
    func formatPrice(){
        
        let largeNumber: Int = merchant.cost
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber)) else { return }
        
        price = formattedNumber
        
    }
}

struct ListingItem_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetail(
            merchant: try! Merchant.init(id: "", city: "", offer: 0, cost: 0, state: "", street: "Merchant Address", zip: "", image: "", cuisine: "Cuisine", name: "Merchant Name", rating: 0, hours: [])
        )
    }
}
