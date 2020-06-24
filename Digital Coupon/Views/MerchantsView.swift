//
//  MerchantsView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct MerchantsView: View {
    
    @ObservedObject var session = FirebaseSession()
    
    @State var ans: Bool = true
    @State var merchants = [Merchant]()
    @State var upper: Int = 1000000
    @State var lower: Int = 0
    @State var order: String = "offer"
    @State var status: String = "all"
    @State var lastEncounteredIndex: Int = 0
    @State var selection: Int? = nil
    @State var filtered: Bool = false
    @State var refreshUserInfo: Bool = false
    
    @State var selectedType: Int = 0
    @State var selectedStatus: Int = 0
    @State var selectedPrice: Int = 1
    @State var cuisineName: String = ""
    @State var user: DCUser?
    
    var body: some View {
        LoadingView(isShowing: .constant(ans)) {
            
            List(0..<self.merchants.count, id: \.self) { index in
                    
                    NavigationLink(destination: ListingDetail(
                        merchant: self.merchants[index],
                        user: self.user,
                        refreshUserInfo: self.$refreshUserInfo
                        )
                    ){
                        ListingItem(
                            merchant: self.merchants[index]
                        )
                    }.onAppear {
                        self.getNextPageIfNecessary(encounteredIndex: index)
                    }
            }
            .listRowInsets(EdgeInsets())
            .padding(.trailing, -14.0)
            .navigationBarTitle("Digital Coupon", displayMode: .inline)
            .onAppear(perform: self.fetch)
            .navigationBarItems(leading:
                NavigationLink(destination: ProileView(user: self.$user), tag: 0, selection: self.$selection) {
                Button(action: {
                withAnimation {
                    self.selection = 0
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.blue)
                }
                }
                , trailing:
                NavigationLink(destination: SortView(selectedType: self.$selectedType, selectedStatus: self.$selectedStatus, selectedPrice: self.$selectedPrice, filtered: self.$filtered, cuisineName: self.$cuisineName), tag: 1, selection: self.$selection)  {
                Button(action: {
                    withAnimation {
                        self.selection = 1
                    }
                }) {
                    Image(systemName: "line.horizontal.3.decrease")
                        .foregroundColor(.blue)
                }
                }
            )
        }
    }
    
    func fetch(){
        let by = ["offer", "rating"]
        let openstatus = ["open", "closed"]
        let prices = ["$", "$$", "$$$", "$$$$"]
        
        if filtered{
            order = by[selectedType]
            status = openstatus[selectedStatus]
            
            switch prices[selectedPrice] {
            case "$$$$":
                upper = 99999
                lower = 10000
            case "$$$":
                upper = 9999
                lower = 1000
            case "$$":
                upper = 999
                lower = 100
            case "$":
                upper = 99
                lower = 0
            default:
                upper = 1000000
                lower = 0
            }
        }
        
        if user == nil || refreshUserInfo{
            if let id = Auth.auth().currentUser?.uid {
                session.getUser(from: "users", withDocumentID: id) { (user) in
                    self.user = user
                    self.refreshUserInfo = false
                }
            }
        }
        
        session.getMerchants(from: "merchants", returning: Merchant.self, orderedBy: order, withUpper: upper, andLower: lower, andStatus: status, loadingMore: false, withCuisine: cuisineName) { (merchants) in
            self.merchants = merchants
            
            self.ans = false
        }
    }
    
    private func getNextPageIfNecessary(encounteredIndex: Int) {
        
        print("encountered index \(encounteredIndex)")
        print("last encountered index \(lastEncounteredIndex)")
        guard lastEncounteredIndex < encounteredIndex else { return }
        guard encounteredIndex == merchants.count - 3 else { return }
        print("encountered index \(encounteredIndex)")
        print("last encountered index \(lastEncounteredIndex)")
        print("")
        lastEncounteredIndex = encounteredIndex
        session.getMerchants(from: "merchants", returning: Merchant.self, orderedBy: order, withUpper: upper, andLower: lower, andStatus: status, loadingMore: true, withCuisine: cuisineName) { (merchants) in
            
            self.merchants.append(contentsOf: merchants)
            self.ans = false
        }
    }
}

struct MerchantsView_Previews: PreviewProvider {
    static var previews: some View {
        MerchantsView()
    }
}
