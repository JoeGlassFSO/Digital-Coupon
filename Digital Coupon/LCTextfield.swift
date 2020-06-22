//
//  LCTextfield.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct LCTextfield: View {
    
    @Binding var value: String
    var placeholder = "Placeholder"
    var icon: String
    var color = Color.blue
    var isSecure = false
    var onEditingChanged: ((Bool)->()) = {_ in }
    
    var body: some View {
        HStack {
            
            Image(systemName: icon).imageScale(.large)
                .padding()
                .foregroundColor(color)
            
            if isSecure{
                SecureField(placeholder, text: self.$value, onCommit: {
                    self.onEditingChanged(false)
                }).padding()
            } else {
                TextField(placeholder, text: self.$value, onEditingChanged: { flag in
                    self.onEditingChanged(flag)
                }).padding()
            }
        }
        .foregroundColor(color)
    }
}

struct LCTextfield_Previews: PreviewProvider {
    static var previews: some View {
        LCTextfield(value: .constant(""), icon: "person.crop.circle")
    }
}
