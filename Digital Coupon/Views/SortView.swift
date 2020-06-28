//
//  SortView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct SortView: View {
    
    @State private var presentCuisineSheet = false
    
    @Binding var selectedType: Int
    @Binding var selectedStatus: Int
    @Binding var selectedPrice: Int
    @Binding var filtered: Bool
    @Binding var cuisineName: String
    var by = ["Offer", "Rating"]
    var openstatus = ["Yes", "No", "All"]
    var prices = ["$", "$$", "$$$", "$$$$"]
    
    var body: some View {
        
        VStack {
                Picker("by type", selection: $selectedType) {
                    ForEach((0 ..< by.count), id: \.self){
                        Text("\(self.by[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            .padding(40)
                
                Text("Price")
                    .fontWeight(.black)
                    .font(.title)
            
                        Picker("Prices", selection: $selectedPrice) {
                            ForEach((0 ..< prices.count), id: \.self){
                                Text("\(self.prices[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    .padding(40)
                        
                        Text("Open now")
                            .fontWeight(.black)
                            .font(.title)
            
                    Picker("open now", selection: $selectedStatus) {
                        ForEach((0 ..< openstatus.count), id: \.self){
                            Text("\(self.openstatus[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                .padding(40)
            
            Button(action: {
                self.presentCuisineSheet.toggle()
            }) {
                HStack {
                    Text("Cuisine")
                        .fontWeight(.black)
                        .font(.title)
                }
            }.sheet(isPresented: self.$presentCuisineSheet) {
                CuisineListView(cuisineName: self.$cuisineName)
            }
            Text(cuisineName)
                    
            
            Spacer()
            
        }.navigationBarTitle("Sort Results By")
            .foregroundColor(.blue)
            .onAppear {
                self.filtered = true
        }
    }
}

//struct SortView_Previews: PreviewProvider {
//    static var previews: some View {
//        SortView(upper: , lower: , order: , status: )
//    }
//}
