//
//  FirebaseSession.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FirebaseSession: ObservableObject{
    var db: Firestore = Firestore.firestore()
    var auth: Auth = Auth.auth()
    
    var lastSnap: DocumentSnapshot?
    
    //    @Published var items: [Merchant] = []
    
    private func reference(to collectionRefence: String) -> CollectionReference{
        
        return db.collection(collectionRefence)
        
    }
    
    func checkAuth() -> User?{
        
        return auth.currentUser
        
    }
    
    func emailPassword(isLogin bool: Bool, withEmail email: String, andPassword password: String, andData docData: [String : Any]?, completion: @escaping (Bool) -> Void){
        if bool {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
                if authResult?.user.uid != nil {
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }else{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let id = authResult?.user.uid{
                    completion(true)
                    self.createUser(withUID: id, andData: docData!)
                }else{
                    print(error!.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    func createUser(withUID uid: String, andData docData: [String : Any]){
        db.collection("users").document(uid).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func redeemOffer(withUID uid: String, fromMerchant merchant: String, offer: Int, savings: Int, andData docData: [String : Any], completion: @escaping (Bool) -> Void) {
        
        let userRef = self.reference(to: "users").document(uid)
        let merRef = self.reference(to: "users/\(uid)/merchants").document(merchant)
        //get merchant info
        merRef.getDocument { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let document = document {
                    if document.exists{
                        let visits = (document.get("visits") as! Int)
                        let saving = (document.get("savings") as! Int)
                        
                        var fullDoc = docData
                        fullDoc.updateValue(visits + 1, forKey:"visits")
                        fullDoc.updateValue(saving + offer, forKey: "savings")
                        
                        //then update said merchant's info
                        merRef.setData(fullDoc) { err in
                            if let err = err {
                                completion(false)
                                print("Error writing document: \(err)")
                            } else {
                                userRef.setData([ "savings": savings], merge: true)
                                completion(true)
                                print("Document successfully written!")
                            }
                        }
                    }else{
                        var fullDoc = docData
                        fullDoc.updateValue(1, forKey:"visits")
                        fullDoc.updateValue(offer, forKey: "savings")
                        //then update said merchant's info
                        merRef.setData(fullDoc) { err in
                            if let err = err {
                                completion(false)
                                print("Error writing document: \(err)")
                            } else {
                                userRef.setData([ "savings": savings], merge: true)
                                completion(true)
                                print("Document successfully written!")
                            }
                        }
                    }
                }else{
                    completion(false)
                }
            }
        }
    }

    func getUser(from collectionReference: String, withDocumentID documentID: String, completion: @escaping (DCUser) -> Void) {
        
        let userRef = reference(to: collectionReference).document(documentID)
        let userMersSRef = reference(to: collectionReference).document(documentID).collection("merchants")
            .order(by: "savings", descending: true)
            .limit(to: 5)
        let userMersVRef = reference(to: collectionReference).document(documentID).collection("merchants")
            .order(by: "visits", descending: true)
            .limit(to: 5)
        
        userRef.getDocument { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let document = document {
                    let id = self.auth.currentUser!.uid
                    let name = (document.get("name") as! String)
                    let email = (document.get("email") as! String)
                    let city = (document.get("city") as! String)
                    let country = (document.get("country") as! String)
                    let state = (document.get("state") as! String)
                    let street = (document.get("street") as! String)
                    let dob = (document.get("dob") as! String)
                    let savings = (document.get("savings") as! Int)
                    
                    //load the user merchant documents
                    userMersSRef.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            let user: DCUser = DCUser(id: id, name: name, city: city, state: state, street: street, dob: dob, country: country, email: email, savings: savings, topSaves: [DCUserMerchants](), topVisits: [DCUserMerchants]())
                            completion(user)
                            print("Error getting saves: \(err)")
                        } else {
                            do{
                                var objectsS = [DCUserMerchants]()
                                for document in querySnapshot?.documents ?? [] {
                                    let object = try document.decode(as: DCUserMerchants.self)
                                    objectsS.append(object)
                                }
                                
                                userMersVRef.getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        let user: DCUser = DCUser(id: id, name: name, city: city, state: state, street: street, dob: dob, country: country, email: email, savings: savings, topSaves: objectsS, topVisits: [DCUserMerchants]())
                                        completion(user)
                                        print("Error getting visits: \(err)")
                                    } else {
                                        do{
                                            var objectsV = [DCUserMerchants]()
                                            for document in querySnapshot?.documents ?? [] {
                                                let object = try document.decode(as: DCUserMerchants.self)
                                                objectsV.append(object)
                                            }
                                            let user: DCUser = DCUser(id: id, name: name, city: city, state: state, street: street, dob: dob, country: country, email: email, savings: savings,topSaves: objectsS, topVisits: objectsV)
                                            completion(user)
                                        }catch{
                                            print(error)
                                        }
                                    }
                                }
                            }catch{
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCuisines(from collectionReference: String, completion: @escaping ([String]) -> Void) {
        
        let firstRef = reference(to: collectionReference)
        
        //load the requested documents
        firstRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var objects = [String]()
                for document in querySnapshot?.documents ?? [] {
                    let object = (document.get("name") as! String)
                    objects.append(object)
                }
                completion(objects)
            }
        }
    }
    
    func getMerchants<T: Decodable>(from collectionReference: String, returning objectType: T.Type, orderedBy order: String, withUpper upper: Int, andLower lower: Int, andStatus status: String, loadingMore boolean: Bool, withCuisine cuisine: String, completion: @escaping ([T]) -> Void) {
        
        let firstRef = reference(to: collectionReference)
            .order(by: order, descending: true)
            .limit(to: 15)
        
        let date = Date()
        var calendar = Calendar.current
        
        if let timeZone = TimeZone(identifier: "EST") {
            calendar.timeZone = timeZone
        }
        
        let currentHour = calendar.component(.hour, from: date)
        print(currentHour)
        
        if !boolean  {
            //load the requested number of documents
            firstRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    do{
                        var objects = [T]()
                        for document in querySnapshot?.documents ?? [] {
                            if cuisine != "" {
                                if ((document.get("cost") as! Int) >= lower && (document.get("cost") as! Int) <= upper) && (document.get("cuisine") as! String) == cuisine{
                                    if status == "all"{
                                        let object = try document.decode(as: objectType.self)
                                        objects.append(object)
                                    }else if status == "open" {
                                        if (document.get("hours") as! [Int]).contains(currentHour){
                                            let object = try document.decode(as: objectType.self)
                                            objects.append(object)
                                        }
                                    }else {
                                        if !(document.get("hours") as! [Int]).contains(currentHour){
                                            let object = try document.decode(as: objectType.self)
                                            objects.append(object)
                                        }
                                    }
                                }
                            } else{
                                if ((document.get("cost") as! Int) >= lower && (document.get("cost") as! Int) <= upper) {
                                    if status == "all"{
                                        let object = try document.decode(as: objectType.self)
                                        objects.append(object)
                                    }else if status == "open" {
                                        if (document.get("hours") as! [Int]).contains(currentHour){
                                            let object = try document.decode(as: objectType.self)
                                            objects.append(object)
                                        }
                                    }else {
                                        if !(document.get("hours") as! [Int]).contains(currentHour){
                                            let object = try document.decode(as: objectType.self)
                                            objects.append(object)
                                        }
                                    }
                                }
                            }
                        }
                        
                        completion(objects)
                        self.lastSnap = querySnapshot!.documents.last
                    }catch{
                        print("\(error)")
                    }
                }
            }
        } else {
            let nextRef = firstRef
                .start(afterDocument: lastSnap!)
            nextRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    do{
                        var objects = [T]()
                        for document in querySnapshot?.documents ?? [] {
                            //  let json = try? JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)\
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)
                        }
                        completion(objects)
                        self.lastSnap = querySnapshot?.documents.last
                    }catch{
                        print(error)
                    }
                }
            }
        }
    }
}
