//
//  ListingDetail.swift
//  Houser
//
//  Created by Mac on 07/11/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import SwiftUI

struct ListingDetail: View {
    
    var merchant: Merchant
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
                    Image("")
                        .resizable()
                        .clipShape(Rectangle())
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.blue, lineWidth: 1))
                        .frame(width: frameSize, height: frameSize)
                        .padding()
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
            
            NavigationLink(destination: RedeemView(merchant: merchant), tag: 1, selection: $selection) {
            Button(action: {
                self.selection = 1
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
}

struct ListingDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetail(
            merchant: try! Merchant.init(id: "", city: "", offer: 0, cost: 0, state: "", street: "", zip: "", image: "", cuisine: "", name: "", rating: 0, hours: [])
        )
    }
}
