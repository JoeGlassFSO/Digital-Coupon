//
//  CuisineListView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//


import SwiftUI

struct CuisineListView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var session = FirebaseSession()
    @State var ans: Bool = true
    @State var cuisines = [String]()
    @Binding var cuisineName: String
    
    var body: some View {
        LoadingView(isShowing: .constant(ans)) {
            
            List(0..<self.cuisines.count, id: \.self) { index in
                Button(action: {
                    self.cuisineName = self.cuisines[index]
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text(self.cuisines[index])
                }
            }.onAppear {
                self.getCuisines()
            }
        }
    }
    
    func getCuisines() {
        
        session.getCuisines(from: "cuisine") { (cuisines) in
            self.cuisines = cuisines
            
            self.ans = false
        }
    }
}

//struct CuisineListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CuisineListView()
//    }
//}
