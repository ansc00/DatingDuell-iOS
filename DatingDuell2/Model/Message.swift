//
//  Message.swift
//  DatingDuell2
//
//  Created by tk on 16.03.21.
//

//represents a Chat Message

import Foundation
import FirebaseAuth

class Message {
    
    //als OPTIONALS
    let fromUserWithUID: String?
    let body: String?
    let timestamp: Int?
    let toUserWithUID: String?

    //datentyp DICTONARY mit String : Any werten
    init(dictionary: [String : Any]) {
        self.fromUserWithUID = dictionary["fromUserWithUID"] as? String
        self.body = dictionary["message"] as? String
        self.timestamp = dictionary["timeStamp"] as? Int
        self.toUserWithUID = dictionary["toUserWithUID"] as? String
    }
    
    func chatPartnerID() -> String? { //rückgabe ist OPTIONAL STring, da der datentyp obne ein OPTIONAL IST!
        if fromUserWithUID == Auth.auth().currentUser?.uid {
            return toUserWithUID
        } else {
            return fromUserWithUID
        }
    }
}

