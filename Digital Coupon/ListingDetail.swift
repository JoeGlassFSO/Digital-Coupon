//
//  ListingDetail.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct ListingDetail: View {
    
    @ObservedObject var session = FirebaseSession()
    
    var merchant: Merchant
    var user: DCUser?
    let frameSize: CGFloat = 65
    @State var selection: Int? = nil
    
    @State var price: String = ""
    var leadPadding: CGFloat = 24
    var trailPadding: CGFloat = 32
    var bottPadding: CGFloat = 16
    
    var body: some View {
        
        VStack {
            
            HStack {
                VStack {
                    
                    Spacer()
                    RemoteImageView(withURL: merchant.image)
                }
                
                Spacer()
            }.frame(height: UIScreen.main.bounds.height/6)
                .background(Color.blue.opacity(0.3))
            
            
            HStack(alignment: .top) {
            VStack(alignment: .leading){
                
                Text(merchant.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                
                Text(merchant.street)
                    .font(.footnote)
                
                Text(merchant.cuisine)
                    .font(.footnote)
                
            }
            
            Spacer()
                
            VStack(alignment: .trailing){
                
                Text(price)
                    .font(.footnote)
                
                }.onAppear(perform: formatPrice)
            }.padding()
            
            Spacer()
            
            Text("\(merchant.offer)")
                .font(.system(size: 100))
                .fontWeight(.semibold)
            
            Spacer()
            
            NavigationLink(destination: RedeemView(merchant: merchant, user: self.user!), tag: 1, selection: $selection) {
            Button(action: {
                self.redeemOffer()
                }){
                    HStack {
                        Spacer()
                        Text("Redeem Offer")
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }.font(.footnote)
                        .background(Color.blue.opacity(0.3))
                }
            }
        }
        .foregroundColor(.blue)
            .navigationBarTitle(merchant.name)
    }
    
    func formatPrice(){
        let largeNumber: Int = merchant.cost
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber)) else { return }
        
        price = formattedNumber
        
    }
    
    func redeemOffer(){
        
        let id = merchant.id
        let image = merchant.image
        let name = merchant.name
        
        
        let docData: [String: Any] = [
            "name" : name,
            "image" : image,
            "id" : id
        ]
        
        
        selection = 1
    }
}

struct ListingDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetail(
            merchant: try! Merchant.init(id: "", city: "", offer: 0, cost: 0, state: "", street: "", zip: "", image: "", cuisine: "", name: "", rating: 0, hours: [], code: "")
        )
    }
}
