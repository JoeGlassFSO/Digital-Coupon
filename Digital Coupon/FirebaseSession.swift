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

    func getMerchants<T: Decodable>(from collectionReference: String, returning objectType: T.Type, withUpper upper: Int, andLower lower: Int, loadingMore boolean: Bool, completion: @escaping ([T]) -> Void) {

        let firstRef = reference(to: collectionReference)
            .limit(to: 9)

        if !boolean  {
            //load the requested number of documents
            firstRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {

                    do{
                        var objects = [T]()
                        for document in querySnapshot?.documents ?? [] {

                            //  let json = try? JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)

//                            if document.get("units") as! Int > 0 {
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)
//                            }
                        }

                        completion(objects)

                        self.lastSnap = querySnapshot!.documents.last

                    }catch{
                        print(error)
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


//import FirebaseDatabase
//
//class DatabaseSession{
//    
//    var ref: DatabaseReference!
//    var posts = [Post]()
//    
//    
//    func getPosts(from child: String, completion: @escaping([Post]) -> Void) {
//        var count = 0
//        
//        ref = Database.database().reference()
//        //let userID = Auth.auth().currentUser?.uid
//        ref.child(child).observe(.childAdded, with: { (snapshot) in
//            count += 1
//            
//            let value = snapshot.value as? NSDictionary
//            
//            let pTxt = value?["pTxt"] as? String
//            let uId = value?["uId"] as? String
//            let pLikes = value?["pLikes"] as? String
//            let uOthername = value?["uOthername"] as? String
//            let uSurname = value?["uSurname"] as? String
//            let uPhoto = value?["uPhoto"] as? String
//            let pTime = value?["pTime"] as? String
//            let uEmail = value?["uEmail"] as? String
//            let pId = value?["pId"] as? String
//            let pComments = value?["pComments"] as? String
//            let pPhoto = value?["pPhoto"] as? String
//            
//            let post = Post(pTxt: pTxt, uId: uId, pLikes: pLikes, uOthername: uOthername, uSurname: uSurname, uPhoto: uPhoto, pTime: pTime, uEmail: uEmail, pId: pId, pComments: pComments, pPhoto: pPhoto)
//            
//            self.posts.append(post)
//            
//            if snapshot.childrenCount == count {
//                completion(self.posts)
//            }
//            
//        }) { (error) in
//            print("FBDBERR: \(error.localizedDescription)")
//        }
//    }
//}
