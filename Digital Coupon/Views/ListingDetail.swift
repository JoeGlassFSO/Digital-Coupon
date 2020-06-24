//
//  ListingDetail.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ListingDetail: View {
    
    @ObservedObject var session = FirebaseSession()
    
    @State var ans: Bool = false
    var merchant: Merchant
    var user: DCUser?
    @Binding var refreshUserInfo: Bool
    let frameSize: CGFloat = 65
    @State var selection: Int? = nil
    
    @State var price: String = ""
    @State var offerStr: String = ""
    var leadPadding: CGFloat = 24
    var trailPadding: CGFloat = 32
    var bottPadding: CGFloat = 16
    
    @State var showAlert = false
    var alert: Alert {
        Alert(
            title: Text("Redemption Status"),
            message: Text("Sorry, we could not redeeem the offer successfully. Please try again"),
            dismissButton: .default(Text("Okay"))
            )
    }
    
    var body: some View {
        
        LoadingView(isShowing: .constant(ans)) {
        VStack {
            
            HStack {
                VStack {
                    
                    Spacer()
                    RemoteImageView(withURL: self.merchant.image)
                }
                
                Spacer()
            }.frame(height: UIScreen.main.bounds.height/6)
                .background(Color.blue.opacity(0.3))
            
            
            HStack(alignment: .top) {
            VStack(alignment: .leading){
                
                Text(self.merchant.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                
                Text(self.merchant.street)
                    .font(.footnote)
                
                Text(self.merchant.cuisine)
                    .font(.footnote)
                
            }
            
            Spacer()
                
            VStack(alignment: .trailing){
                
                Text(self.price)
                    .font(.footnote)
                
            }.onAppear(perform: self.formatPrice)
            }.padding()
            
            Spacer()
            
            Text("\(self.offerStr)")
                .font(.system(size: 100))
                .fontWeight(.semibold)
            
            Spacer()
            
            NavigationLink(destination: RedeemView(merchant: self.merchant, user: self.user!), tag: 1, selection: self.$selection) {
            Button(action: {
                self.ans = true
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
        .alert(isPresented: self.$showAlert, content: { self.alert })
        .foregroundColor(.blue).navigationBarTitle(self.merchant.name)
    }
    }
    
    func formatPrice(){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        let largeNumber: Int = merchant.cost
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber)) {
        price = formattedNumber
        }
        
        let largeNumber2: Int = merchant.offer
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber2)) {
        offerStr = formattedNumber
        }
    }
    
    func redeemOffer(){
        
        let id = merchant.id
        let image = merchant.image
        let name = merchant.name
        let savings = merchant.offer + user!.savings
        let offer = merchant.offer
        
        let docData: [String: Any] = [
            "name" : name,
            "image" : image
        ]
        
        if let uid = Auth.auth().currentUser?.uid {
            session.redeemOffer(withUID: uid, fromMerchant: id, offer: offer, savings: savings, andData: docData) { (success) in
            self.ans = false
                if success {
                    self.selection = 1
                    self.refreshUserInfo = true
                }else{
                    self.showAlert.toggle()
                }
            }
        }
    }
}

struct ListingDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetail(
            merchant: try! Merchant.init(id: "", city: "", offer: 0, cost: 0, state: "", street: "", zip: "", image: "", cuisine: "", name: "", rating: 0, hours: [], code: ""), refreshUserInfo: .constant(false)
        )
    }
}
