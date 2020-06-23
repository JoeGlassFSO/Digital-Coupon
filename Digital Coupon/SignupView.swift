//
//  SignupView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var session = FirebaseSession()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var dob = ""
    @State private var country = ""
    @State private var city = ""
    @State private var street = ""
    @State private var state = ""
    
    @State private var formOffset: CGFloat = 0
    
    @Binding var isLoggedIn: Bool
    
    @State var errorText: String?
    private let loginKey = "loggedIn"
    
    @Binding var isLoggingIn: Bool
    
    var body: some View {
        
        return ScrollView {
            VStack {
                Text("Create an Account").font(.headline)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do").multilineTextAlignment(.center).padding().font(.callout)
                VStack(alignment: .leading) {
                    
                    Text("Full Name").font(.system(size: 12))
                    TextField("", text: $name)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                    
                    Text("Email").font(.system(size: 12))
                    TextField("", text: $email)
                        .keyboardType(.emailAddress)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                    
                    Text("Password").font(.system(size: 12))
                    SecureField("", text: $password)
                        .textContentType(.password)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                }.padding()
                
                Text("Personal Information").font(.headline).padding()
                VStack(alignment: .leading) {
                    
                    Text("Date of birth").font(.system(size: 12))
                    TextField("", text: $dob)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                    
                    Text("Country/Region").font(.system(size: 12))
                    TextField("", text: $country)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                    
                    Text("State").font(.system(size: 12))
                    TextField("", text: $state)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                    
                    Text("City").font(.system(size: 12))
                    TextField("", text: $city)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                    
                    Text("Street").font(.system(size: 12))
                    TextField("", text: $street)
                        .clipShape(Rectangle())
                        .padding(12)
                        .overlay(Rectangle().stroke(Color.blue, lineWidth: 0.5))
                    
                }.padding()
                
                Button(action: {
                    if self.isValidEmail(self.email){
                        self.signUpUser(email: self.email, pass: self.password)
                    }else {
                        self.errorText = "Please enter a valid email"
                    }
                }){
                    HStack {
                        Spacer()
                        Text("Create Account")
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }.font(.footnote)
                        .background(Color.blue.opacity(0.3))
                }
            }
                .offset(y: self.formOffset)
                .foregroundColor(.blue)
        }.modifier(AdaptsToSoftwareKeyboard())
    }
    
    func signUpUser(email: String, pass: String){
        print("signing up...")
        
        isLoggingIn = true
        
        let docData: [String: Any] = [
            "name" : name,
            "email" : email,
            "dob" : dob,
            "country" : country,
            "city" : city,
            "street" : street,
            "state" : state,
            "offers" : 0
        ]
        
        session.emailPassword(isLogin: false, withEmail: email, andPassword: pass, andData: docData) { (isLoggedIn) in
            self.isLoggingIn = false
            UserDefaults.standard.set(isLoggedIn, forKey: self.loginKey)
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

