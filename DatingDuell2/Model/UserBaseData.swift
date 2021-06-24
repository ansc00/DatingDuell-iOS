//
//  UserBaseData.swift
//  DatingDuell
//
//  Created by tk on 04.06.21.
//

//Model for basis data that are necessary

import UIKit


class MyCoordinate {
    var lat: Double?
    var lon: Double?
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

class UserBaseData {
    var id: String?
    var email: String?
    
    var name: String?
    var gender: String?
    var birthday: String?
    var searchedGender: String?
    
    var image: UIImage?
    
    var likes: Int?
    var dislikes: Int?
    var userCounter: Int?
    
    var myCoordinate: MyCoordinate
    
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.email = dictionary["email"] as? String
        
        self.name = dictionary["name"] as? String
        self.gender = dictionary["gender"] as? String
        self.birthday = dictionary["birthday"] as? String
        self.searchedGender = dictionary["searchedGender"] as? String
//        self.image = dictionary["image"] as? UIImage
        
        self.likes = dictionary["likes"] as? Int
        self.dislikes = dictionary["dislikes"] as? Int
        self.userCounter = dictionary["userCounter"] as? Int
        
         
        let lat = dictionary["lat"] as? Double ?? 0.0
        let lon = dictionary["lon"] as? Double ?? 0.0
        self.myCoordinate = MyCoordinate(lat: lat,
                                        lon: lon)
    }
    
    init(id: String, email: String, name: String, gender: String, birthday: String, searchedGender: String, image: UIImage,
         likes: Int, dislikes: Int, userCounter: Int , myCoordinate: MyCoordinate ) {
        self.id = id
        self.email = email
        
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.searchedGender = searchedGender
        
        self.image = image
        
        self.likes = likes
        self.dislikes = dislikes
        self.userCounter = userCounter
        
        self.myCoordinate = myCoordinate
    }
}
