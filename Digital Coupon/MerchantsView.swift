//
//  MerchantsView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct MerchantsView: View {
    
    @ObservedObject var session = FirebaseSession()
    
    @State var ans: Bool = true
    @State var merchants = [Merchant]()
    @State var upper: Int = 1000000
    @State var lower: Int = 0
    @State var lastEncounteredIndex: Int = 0
    
    var body: some View {
        LoadingView(isShowing: .constant(ans)) {
            
            List(0..<self.merchants.count, id: \.self) { index in
                    
                    NavigationLink(destination: ListingDetail(
                        merchant: self.merchants[index]
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
        }
    }
    
    func fetch(){
        
        session.getMerchants(from: "merchants", returning: Merchant.self, withUpper: upper, andLower: lower, loadingMore: false) { (merchants) in
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
        session.getMerchants(from: "merchants", returning: Merchant.self, withUpper: upper, andLower: lower, loadingMore: true) { (merchants) in
            
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
