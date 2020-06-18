//
//  ContentView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct ContentView: View {
    
    @State var image: UIImage?
    @State var show = true
    @State var isLoggedIn: Bool = true
    @State var isLoggingIn: Bool = false
    
    private let loginKey = "loggedIn"
    
    @ObservedObject var session = FirebaseSession()
    
    @State var errorText: String?
    
    var body: some View {
        
        VStack{
            NavigationView{
                ZStack{
                    VStack {
                        if show {
                            if isLoggedIn {
                                //list the merchants
                                MerchantsView()
                            } else {
                                if !isLoggingIn{
                                    //LoginView(isLoggedIn: self.$isLoggedIn, errorText: self.$errorText, isLoggingIn: self.$isLoggingIn, apicall: self.apicall, filters: self.$filters).transition(.move(edge: .bottom))
                                }else{
                                    VStack(alignment: .center) {
                                        Spacer()
                                        ActivityIndicator()
                                            .frame(width: 60, height: 60)
                                        Spacer()
                                    }.foregroundColor(Color.blue)
                                }
                            }
                        } else {
                            //                    PageViewContainer( viewControllers: Page.getAll.map({  UIHostingController(rootView: PageView(page: $0) ) }), presentSignupView: {
                            //                        withAnimation {
                            //                            self.show = true
                            //                        }
                            //                        UserDefaults.standard.set(true, forKey: self.initialLaunchKey)
                            //                    }).transition(.scale)
                        }
                    }.frame(maxHeight: .infinity)
                        //.background(Color.backgroundColor)
                        .edgesIgnoringSafeArea(.bottom)
                        .onTapGesture {
                            // UIApplication.shared.endEditing()
                    }
                    .onAppear(){
                        //self.checkloginStatus()
                    }
                }
            }
        }
    }
    
    func checkloginStatus(){
        if session.checkAuth() != nil{
            //logged in
            self.isLoggedIn = true
        } else {
            //not logged in
            self.isLoggedIn = false
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
