//
//  RedeemView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct RedeemView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var merchant: Merchant
    var user: DCUser
    
    @State var price: String = ""
    @State var saves: String = ""
    let frameSize: CGFloat = UIScreen.main.bounds.width/2
    
    var body: some View {
        
        VStack{
            Spacer()
            
            VStack{
                
                Text("You just saved")
                    .fontWeight(.heavy)
                Text(price)
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding()
                    .padding()
                Text("Confirmation code \(merchant.code)")
                    .fontWeight(.medium)
                    .font(.caption)
                
            }.onAppear(perform: formatPrice)
                .overlay(RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.blue, lineWidth: 1))
                .padding([.leading, .trailing])
            
            Text("You have saved a total of \(saves)")
                .font(.caption)
                .fontWeight(.medium)
                .padding()
            
            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                HStack {
                    Spacer()
                    Text("Continue")
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }.font(.footnote)
                    .background(Color.blue.opacity(0.3))
            }
            
        }
        .foregroundColor(.blue)
        .navigationBarTitle("")
    }
    
    func formatPrice(){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        let largeNumber: Int = merchant.offer
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber)) else { return }
        
        price = formattedNumber
        
        let largeNumber2: Int = user.savings + merchant.offer
        guard let formattedNumber2 = numberFormatter.string(from: NSNumber(value: largeNumber2)) else { return }
        
        saves = formattedNumber2
        
    }
}

struct RedeemView_Previews: PreviewProvider {
    static var previews: some View {
        RedeemView(
            merchant: try! Merchant.init(id: "", city: "", offer: 0, cost: 0, state: "", street: "", zip: "", image: "", cuisine: "", name: "", rating: 0, hours: [], code: ""), user: DCUser.init(id: "", name: "", city: "", state: "", street: "", dob: "", country: "", email: "", savings: 0, topSaves: [DCUserMerchants](), topVisits: [DCUserMerchants]()))
    }
}
