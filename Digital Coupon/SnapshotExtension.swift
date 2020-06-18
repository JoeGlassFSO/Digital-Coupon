//
//  SnapshotExtension.swift
//  Digital Coupon
//
//  Created by Joe Glass on 5/29/20.
//  Copyright © 2020 Joe Glass. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum DocumentSnapshotExtensionError:Error {
    case decodingError
}

let db: Firestore = Firestore.firestore()

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        //print("decoding snapshot for ", documentID)
        do {
            guard var documentJson = self.data() else {throw DocumentSnapshotExtensionError.decodingError}
            if  includingId{
                documentJson["id"] = documentID
            }
            
            
            //print(documentJson["imageUrl"]!)
            
            //transform any values in the data object as needed
            documentJson.forEach { (key: String, value: Any) in
                switch value{
//                case let ref as DocumentReference:
//                    //print("document ref path", ref.path)
//                    documentJson.removeValue(forKey: key)
//                    break
                case let ts as Timestamp: //convert timestamp to date value
                    //print("converting timestamp to date for field \(key)")
                    let date = ts.dateValue()
                    
                    let jsonValue = Int((date.timeIntervalSince1970 * 1000).rounded())
                    documentJson[key] = jsonValue
                    
                    //print("set \(key) to \(jsonValue)")
                    break
                default:
                    break
                }
            }
            
            //print("getting doucument data")
            let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
            //print("Got document data, decoding into object", documentData)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            
            let decodedObject = try decoder.decode(objectType, from: documentData)
            //print("finished decoding DocumentSnapshot")
            
            
            return decodedObject
        } catch {
            print("failed to decode", error)
            throw error
        }
        
    }
}
