//
//  ProileView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct ProileView: View {
    
    @Binding var user: DCUser?
    @State var saves = ""
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Spacer()
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.main.bounds.height/6, alignment: .center)
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }.background(Color.blue.opacity(0.3))
                VStack(alignment: .leading){
                    Text(user!.name)
                        .font(.title)
                        .fontWeight(.medium)
                    Text("\(user!.city), \(user!.state)")
                        .font(.caption)
                }.padding(30)
                
                VStack(alignment: .leading){
                    Text("Total Saved")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding()
                    
                    HStack{
                        Spacer()
                        Text(saves)
                            .font(.system(size: 42))
                            .fontWeight(.medium)
                        Spacer()
                    }.padding()
                        .onAppear(perform: formatPrice)
                    Divider()
                        .background(Color.blue.opacity(0.5))
                    Text("Top Merchant. Savings")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding()
                    
                    HStack{
                        ForEach(0..<user!.topSaves.count){ i in
                            RemoteImageView(withURL: self.user!.topSaves[i].image, isCircle: true)
                        }
                    }.padding()
                    
                    Divider()
                        .background(Color.blue.opacity(0.5))
                    Text("Top Frequented Merchants")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding()
                    
                    HStack{
                        ForEach(0..<user!.topVisits.count){ i in
                            RemoteImageView(withURL: self.user!.topVisits[i].image, isCircle: true)
                        }
                    }.padding()
                    
                    Divider()
                        .background(Color.blue.opacity(0.5))
                }.background(Color.blue.opacity(0.1))
                
                Spacer()
            }
        }.navigationBarTitle("PROFILE")
            .foregroundColor(.blue)
    }
    
    func formatPrice(){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        let largeNumber2: Int = user!.savings
        guard let formattedNumber2 = numberFormatter.string(from: NSNumber(value: largeNumber2)) else { return }
        
        saves = formattedNumber2
    }
}

//struct ProileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProileView(user: DCUser.init(id: "", name: "", city: "", state: "", street: "", dob: "", country: "", email: ""))
//    }
//}
