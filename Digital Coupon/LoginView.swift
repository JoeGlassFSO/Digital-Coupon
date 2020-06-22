//
//  LoginView.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//


import SwiftUI
import FBSDKLoginKit
import Firebase
import GoogleSignIn

struct LoginView: View {
    
    @ObservedObject var session = FirebaseSession()
    
    let frameSize: CGFloat = 75
    @State private var email = ""
    @State private var password = ""
    @State private var formOffset: CGFloat = 0
    @State var selection: Int? = nil
    @Binding var isLoggedIn: Bool
    @Binding var errorText: String?
    @Binding var isLoggingIn: Bool
    
    private let loginKey = "loggedIn"
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            
            Spacer()
            Text("Digital Coupon").font(.title)
                .foregroundColor(.blue)
            
                Spacer()
            
            VStack {
                
                Text(self.errorText ?? " ")
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.red.opacity(0.7))
                    .font(.system(size: 16))
                
                LCTextfield(value: self.$email, placeholder: "Email", icon: "envelope.fill", onEditingChanged: { flag in
                    withAnimation {
                        self.formOffset = flag ? -150 : 0
                    }
                })
                
                LCTextfield(value: self.$password, placeholder: "Password", icon: "lock.fill", isSecure: true)
            }
            Spacer()
            VStack{
                loginGoogle()
                    .frame(width: 100, height: 50)
                loginFb(isLoggedIn: self.$isLoggedIn)
                    .frame(width: 100, height: 50)
            }
            HStack{
                Spacer()

//                Button(action: {
                
//                }) {
//                    HStack {
//                        Image("fb")
//                            .resizable()
//                            .clipShape(Circle())
//                            .padding(10)
//                            .overlay(Circle().stroke(Color.black, lineWidth: 0.3))
//                            .padding()
//                            .frame(width: frameSize, height: frameSize)
//                    }
//                }
                
//                Button(action: {
//
//                }) {
//                    HStack {
//
//                        Image("apple")
//                            .resizable()
//                            .clipShape(Circle())
//                        .padding(10)
//                            .overlay(Circle().stroke(Color.black, lineWidth: 0.3))
//                            .padding()
//                            .frame(width: frameSize, height: frameSize)
//                    }
//                }
                
//                Button(action: {
//
//                }) {
//                    HStack {
//
//                        Image("gplus")
//                            .resizable()
//                            .clipShape(Circle())
//                            .padding(10)
//                            .overlay(Circle().stroke(Color.black, lineWidth: 0.3))
//                            .padding()
//                            .frame(width: frameSize, height: frameSize)
//                    }
//                }
                
                Spacer()
            }
            Spacer()

            NavigationLink(destination:
                SignupView(isLoggedIn: self.$isLoggedIn, isLoggingIn: self.$isLoggingIn ),  tag: 0, selection: self.$selection
            ){
                
            Button(action: {
                self.selection = 0
            }) {
                HStack {
                    Text("Create an account").accentColor(Color.accentColor).font(.caption)
                }
            }
                }
            
            
            Button(action: {
                
                if self.isValidEmail(self.email){
                    self.logInUser(email: self.email, pass: self.password)
                } else {
                    self.errorText = "Please enter a valid email"
                }
            }){
                HStack {
                    Spacer()
                    Text("Login")
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }.font(.footnote)
                    .background(Color.blue.opacity(0.3))
            }
            
        }
            .foregroundColor(.blue)
            .offset(y: self.formOffset)
    }
    
    func logInUser(email: String, pass: String){
        print("logn in...")
       
        isLoggingIn = true
        session.emailPassword(isLogin: true, withEmail: email, andPassword: pass, andData: nil) { (isLoggedIn) in
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

struct loginFb: UIViewRepresentable {
    
    @Binding var isLoggedIn: Bool
    
    func makeCoordinator() -> loginFb.Coordinator {
        return loginFb.Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<loginFb>) -> FBLoginButton {
        let loginButton = FBLoginButton()
        loginButton.delegate = context.coordinator
        return loginButton
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<loginFb>) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate{
        let parent: loginFb
        
        init(_ parent: loginFb) {
            self.parent = parent
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (res, er) in
                    if er != nil{
                        print(er!.localizedDescription)
                        return
                    }
                    self.parent.isLoggedIn = true
                    print("success")
                }
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
        
    }
}

struct loginGoogle: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<loginGoogle>) -> GIDSignInButton {
        let loginButton = GIDSignInButton()
        loginButton.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return loginButton
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<loginGoogle>) {
        
    }
    
}
