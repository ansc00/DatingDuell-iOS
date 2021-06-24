//
//  Database.swift
//  DatingDuell
//
//  Created by tk on 31.05.21.
//


//Database to save and retrieve data from Firebase Firestore

import Foundation
import Firebase

class Database {
    
    //create a new user in Firebase Firestore DB
    // @noescape in order to prevent them from being stored or captured, which guarantees they won't outlive the duration of the function call.
    static func createNewUserInFirebaseDB(user: User, complitionHandler: @escaping (Bool) -> Void) {
        
        Firestore.firestore().collection("users").document(user.id!).setData( [
            "userId": user.id!,
            "userEmail": user.email!,
            "userRole": user.role!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                complitionHandler(false)
            } else {
                //user succesful created
                
                self.createOrUpdateDefaultInfo { (success, createdUserCounter) in
                    if success {
                        self.createUserBaseData(userId: user.id!, value: createdUserCounter) { success in
                            if success {
                                complitionHandler(true)
                            } else {
                                complitionHandler(false)
                            }
                        }
                        
                    } else {
                        complitionHandler(false)
                    }
                }
                
            }
        }
    }
    
    //Read userData from Firebase Firestore DB
    static func getUserById(id: String, complitionHandler: @escaping (User?) -> Void) {
        
        var user: User?
        //read userData from DB
        Firestore.firestore().collection("users").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                let _ = document.data().map(String.init(describing:)) ?? "nil"
                //                            print("Document data: \(dataDescription)")
                user = User(id: document.get("userId") as? String,
                            email: document.get("userEmail") as? String,
                            role: document.get("userRole") as? String )
                
            } else {
                print("Document does not exist")
            }
            
            complitionHandler(user)
            
        }
        
    }
    
    
    
    
    
    
    //save BaseData from User in Firestore DB
    static func saveBaseDataToDB(_ userBaseData: UserBaseData, complitionHandler: @escaping (Bool) -> Void) {
        
        guard let uploadImage = userBaseData.image!.jpegData(compressionQuality: 0.1) else { return } //compress data // 1.0 best quali to 0.0 worst quali
        //upload firebase to firestore
        // Create a root reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        //        let imageUUIDString = UUID().uuidString
        let imageRef = storageRef.child("images").child(userBaseData.id!)
        
        // Upload the file to the path "images/rivers.jpg"
        let _ = imageRef.putData(uploadImage, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print("Metdata ERROR")
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let _ = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("DownloadURL error")
                    return
                }
                
                //save userBaseData to DB
                Firestore.firestore().collection("userBaseData").document(userBaseData.id!).updateData( [
                    "id": userBaseData.id! as String,
                    "email": userBaseData.email! as String,
                    "name": userBaseData.name! as String,
                    "gender": userBaseData.gender! as String,
                    "birthday": userBaseData.birthday! as String,
                    "searchedGender": userBaseData.searchedGender! as String,
                    "photoURL": downloadURL.absoluteString as String,
                    "likes": userBaseData.likes! as Int,
                    "dislikes": userBaseData.dislikes! as Int,
                    //userCounter DONT UPDATE!
                    "lat" : userBaseData.myCoordinate.lat! as Double,
                    "lon" : userBaseData.myCoordinate.lon! as Double
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        complitionHandler(false)
                    } else {
                        //user succesful created
                        complitionHandler(true)
                    }
                }
                
            }
        }
    }
    
    //does the user Base Data exists
    static func isUserBaseDataAvailable(userId: String, complitionHandler: @escaping (Bool) -> Void) {
        
        Firestore.firestore().collection("userBaseData").document(userId).getDocument { docusnapshot, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                complitionHandler(false)
                return
            }
            
            if docusnapshot?.exists == true  && docusnapshot?.get("id") != nil {
                complitionHandler(true)
            } else {
                complitionHandler(false)
            }
            
        }
    }
    
    
    
    
    
    static func getAllUserBaseDataFromDB(_ dontGetThisUserById: String, complitionHandler: @escaping ([UserBaseData]) -> Void){
        // Create a root reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        
        var  userBaseDataArr = [UserBaseData]()
        
        Firestore.firestore().collection("userBaseData").getDocuments { querysnap, err in
            if err != nil {
                
            } else {
                
                for doc in querysnap!.documents {
                    let dict = doc.data()
                    let userBaseData = UserBaseData(dictionary: dict)
                    
                    
//                    let photoURL = doc.get("photoURL") as! String //download later the image with this URL
                 
                    
                    // Create a reference to the file you want to download
                    let imageRef = storageRef.child("images").child(doc.documentID)
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let err = error {
                            // Uh-oh, an error occurred!
                            print(err.localizedDescription)
                            return
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)!
                            
                            //set image
                            userBaseData.image = image
                            
                            if userBaseData.id != dontGetThisUserById {
                                print("added id: \(String(describing: userBaseData.id))")
                                userBaseDataArr.append(userBaseData)
                            }
                            
                            complitionHandler(userBaseDataArr)
                            
                        }
                    }
                }
                
                
                
                
                
            }
        }
    }
    
    //get BaseData from User
    static func getUserBaseDataFromDB(_ userId: String, complitionHandler: @escaping (UserBaseData) -> Void) {
        // Create a root reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        print("getUserBaseDataFromDB aufruf")
        
        //get userBaseData from DB
        Firestore.firestore().collection("userBaseData").document(userId).getDocument { documentSnapshot, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if documentSnapshot?.exists == true {
                let dict = documentSnapshot?.data()
                let userBaseData = UserBaseData(dictionary: dict!)
                
//                let photoURL = documentSnapshot?.get("photoURL") as! String //download later the image with this URL
                
                // Create a reference to the file you want to download
                let imageRef = storageRef.child("images").child(userId)
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let err = error {
                        // Uh-oh, an error occurred!
                        print(err.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)!
                        
                        
                        userBaseData.image = image
                        
                        print("database: übergeben userBasedata mti id: " + userBaseData.id!)
                        complitionHandler(userBaseData)
                        
                    }
                }
            }
        }
        
    }
    
    static func getAllMessages(fromUserWithUID: String, toUserWithUID: String, complitionHandler: @escaping ([Message]) -> () ){
        Firestore.firestore().collection("messages").whereField("fromUserWithUID", isEqualTo: fromUserWithUID)
            .whereField("toUserWithUID", isEqualTo: toUserWithUID).getDocuments { querySnap, err in
                if err != nil {
                    return
                } else {
                    guard let docs = querySnap?.documents else { return }
//                    print(docs.count)
                    var messageArr = [Message]()
                    
                    for doc in docs {
                        let message = Message(dictionary: doc.data() )
//                        print(message.fromUserWithUID! + " TO: " + message.toUserWithUID!)
                        messageArr.append(message)
                    }
                    complitionHandler(messageArr)
                }
            }
    }
    
    
//    static func getMessageFromDB(messageId: String, complitionHandler: @escaping (Message) -> () ){
//        Firestore.firestore().collection("messages").document(messageId).getDocument { docSnap, err in
//            if err !=  nil {
//                return
//            } else {
//                let dict = docSnap?.data()
//
//                let message = Message(dictionary: dict!)
//                complitionHandler(message)
//            }
//        }
//    }
    
    static func getMyChatPartnersIDsFromDB(fromThisUserId: String, complitionHandler: @escaping ([String]) -> () ){
        Firestore.firestore().collection("user-messages").document(Auth.auth().currentUser!.uid).getDocument { docSnap, err in
            if err != nil {
                return
            } else {
                
                guard  let dict = docSnap?.data()  else { return }
                var allUserBaseDataIds = [String]()
//                var allMessageIds = [String]()
                for (key, value) in dict {
                    var v = value as! String
//                    var k = key as! String
                    v = v.trimmingCharacters(in: .whitespaces)
//                    print("MESSAGE IDS: \(key)")
                    
                    
                    if !allUserBaseDataIds.contains(v) {
//                        print("-----------------> ADDING \(v)")
                        allUserBaseDataIds.append(v)
                    }
                    
//                    allMessageIds.append(k)
                   
                }
                
                complitionHandler(allUserBaseDataIds)
            }
        }
    }
    
    
    static func saveMessageToDB(fromId: String, toId: String, _ messageBody: String, complitionHandler: @escaping (Bool) -> () ){
        
        
        // Zeitpunkt der Nachricht
        let timeStamp = Int(Date().timeIntervalSince1970)
        
        
        
        let dicData : [String: Any] = ["message" : messageBody,
                                       "fromUserWithUID" : fromId,
                                       "toUserWithUID" : toId,
                                       "timeStamp" : timeStamp] //dict erzeugen
        
        
        
        Firestore.firestore().collection("messages").addDocument(data: dicData).addSnapshotListener({ docuSnap, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let messageID =  docuSnap?.documentID else { return }
            
            
            let dict1 = [messageID : toId] //messageID + zu wem die Nachricht ging
            
            
            
            //getDocument(compliton) holt nur 1x die daten
            
            //listner der auf änderungen hört
//            db.collection("cities").whereField("state", isEqualTo: "CA")
//                .addSnapshotListener { querySnapshot, error in
//                    guard let snapshot = querySnapshot else {
//                        print("Error fetching snapshots: \(error!)")
//                        return
//                    }
//                    snapshot.documentChanges.forEach { diff in
//                        if (diff.type == .added) {
//                            print("New city: \(diff.document.data())")
//                        }
//                        if (diff.type == .modified) {
//                            print("Modified city: \(diff.document.data())")
//                        }
//                        if (diff.type == .removed) {
//                            print("Removed city: \(diff.document.data())")
//                        }
//                    }
//                }
            
            
            //fromId
            Firestore.firestore().collection("user-messages").document(fromId).getDocument { docSnap, err in
                if err != nil {
                    complitionHandler(false)
                    return
                } else {
                    if docSnap?.exists == false {
                        Firestore.firestore().collection("user-messages").document(fromId).setData(dict1)
                    } else {
                        //Eigenloggter Nutzer lädt nur Nachrichten welche für ihn bestimmt sind
                        Firestore.firestore().collection("user-messages").document(fromId).updateData(dict1)
                    }
                    complitionHandler(true)
                }
            }
            
            let dict2 = [messageID : fromId] //messageID + von wem die Nachricht kam!
            
            //toId
            Firestore.firestore().collection("user-messages").document(toId).getDocument { docSnap, err in
                if err != nil {
                    complitionHandler(false)
                    return
                } else {
                    if docSnap?.exists == false {
                        Firestore.firestore().collection("user-messages").document(toId).setData(dict2)
                    } else {
                        //wenn der eingeloggte Nutzer den Leuten schreibt, wollen die auch bescheid wissen und diese nachricht in Echtzeit laden
                        //nutzer zu dem die nachricht ERHALTEN SOLL
                        Firestore.firestore().collection("user-messages").document(toId).updateData(dict2)
                    }
                    complitionHandler(true)
                }
            }
            
            
            
            
            
        })
    }
    
    
    //get baseData from User
    static func getUserBaseDataFilteredFromDB(myUserId: String, searchedGender: String, myGender: String, complitionHandler: @escaping ([UserBaseData]) -> Void) {
        // Create a root reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        var searchedGenderArr = [String]()
        
        switch searchedGender {
        case "Man":
            searchedGenderArr.append(searchedGender)
            break
        case "Woman":
            searchedGenderArr.append(searchedGender)
            //            searchedGenderArr.append("Man") //DELETE LATER
            break
        case "Both":
            searchedGenderArr.append("Man")
            searchedGenderArr.append("Woman")
            break
        default:
            break
        }
        print(searchedGenderArr)
        
        //get userBaseData from DB
        Firestore.firestore().collection("userBaseData").whereField("gender", in: searchedGenderArr)
            //                                                        .whereField("id", isNotEqualTo: myUserId) //dont show me in results
            //                                                        .whereField("searchedGender", isEqualTo: myGender )
            .getDocuments { querySnapshot, err in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    var otherUsersBaseData = [UserBaseData]()
                    
                    for document in querySnapshot!.documents {
                        
                        let id = document.documentID
                        let myDict: [String: Any] = document.data()
                        
                        let userBaseData = UserBaseData(dictionary: myDict)
                        
//                        let photoURL =  myDict["photoURL"] as! String
                     
                        // Create a reference to the file you want to download
                        let imageRef = storageRef.child("images").child(id)
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let err = error {
                                // Uh-oh, an error occurred!
                                print(err.localizedDescription)
                            } else {
                                // Data for "images/island.jpg" is returned
                                let image = UIImage(data: data!)!
                                
                                
                                userBaseData.image = image
                                
                                //dont show me in results
                                if (userBaseData.id != myUserId) {
                                    otherUsersBaseData.append(userBaseData)
                                }
                                //                            print(userBaseData)
                                //                            print(otherUsersBaseData.count)
                                
                                complitionHandler(otherUsersBaseData)
                            }
                        }
                    }
                }
            }
        
    }
    
    
    
    static func createOrUpdateDefaultInfo(complitionHandler: @escaping (Bool, Int) -> Void) {
        
        Firestore.firestore().collection("default").document("info").getDocument { docSnap, err in
            if err != nil {
                complitionHandler(false, 0)
                return
            } else {
                
                if docSnap?.exists == false { //snapshot doesnt exists
                    print("default/info DONT EXISTS creating new one with value: 1")
                    //create new
                    Firestore.firestore().collection("default").document("info").setData( [
                        "createdUserCounter": 1
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                            complitionHandler(false, 0)
                        } else {
                            //user succesful created
                            complitionHandler(true, 1)
                        }
                    }
                } else {
                    //snapshot exists
                    var counter = docSnap?.get("createdUserCounter") as! Int
                    counter += 1
                    print("default/info exisits with value: " + String(counter))
                    
                    
                    //update value in Default Info
                    Firestore.firestore().collection("default").document("info").updateData(["createdUserCounter" : counter ]) { err in
                        if err != nil {
                            complitionHandler(false, 0)
                        } else {
                            complitionHandler(true, counter) //send true > aka exists
                        }
                    }
                    
                    
                }
            }
        }
        
    }
    
    
    

    //one time only
    private static func createUserBaseData(userId: String, value: Int, complitionHandler: @escaping (Bool) -> Void) {
        
        Firestore.firestore().collection("userBaseData").document(userId).setData( ["userCounter" : value ]) { err in
            if err != nil {
                complitionHandler(false)
                return
            } else {
                
                complitionHandler(true)
                
            }
        }
    }
    
    
    

    
    static func getOneUserFromDBRandomly(_ dontShowUserWithThisUserCounter: [Int], wishedGender: String,  complitionHandler: @escaping (UserBaseData) -> Void) {
        // Create a root reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        print("dontShowUserWithThisUserCounter: \(dontShowUserWithThisUserCounter)")
//        var isDoneArr = [Bool](repeating: false, count: dontShowUserWithThisUserCounter.count)
        
        //read overall userstatistik
        Firestore.firestore().collection("default").document("info").getDocument { docuSnap, err in
            if err != nil {
                
            } else {
                var rounds = 0
                let counter = docuSnap?.get("createdUserCounter") as! Int
                var rnd: Int?
                
                repeat {
                    rnd = Int.random(in: 1...counter)
                    print("random number between 1 and " + String(counter) + " is: \(String(describing: rnd))")
//                    var i = 0
                    
//                    for userNumber in dontShowUserWithThisUserCounter {
//                        if userNumber as Int != rnd {
//                            isDoneArr[i] = false
//                        } else {
//                            isDoneArr[i] = true
//                        }
//                        i += 1
//                        rounds += 1
//                    }
                    rounds += 1
                  
                    if rounds > 20 {
                        return
                    }
                  print(rounds)
                } while  (dontShowUserWithThisUserCounter.contains(rnd!))
//                } while  (isDoneArr.allSatisfy({ arrayBoolValue in //check if all values are TRUE
//                    return arrayBoolValue
//                })) //exclude my personaly number // dont show me
                
//                isDoneArr = [Bool](repeating: false, count: dontShowUserWithThisUserCounter.count)
                
                
                //                print("randomnumber: \(rnd)")
                
                //get user snapshot
                Firestore.firestore().collection("userBaseData")
                    .limit(to: 1)
//                    .whereField("searchedGender", isEqualTo: wishedGender)
                    .whereField("userCounter", isEqualTo: rnd! as Int).getDocuments { querySnapshot, err in
                        if err != nil {
                            print(err?.localizedDescription)
                            return
                        } else {
                            
                            for document in querySnapshot!.documents {
                                
                                let id = document.documentID
                                let myDict: [String: Any] = document.data()
                                let userBaseData = UserBaseData(dictionary: myDict)
//                                let photoURL =  myDict["photoURL"] as! String
                                
                                
                                // Create a reference to the file you want to download
                                let imageRef = storageRef.child("images").child(id)
                                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                    if let err = error {
                                        // Uh-oh, an error occurred!
                                        print(err.localizedDescription)
                                        return
                                    } else {
                                        // Data for "images/island.jpg" is returned
                                        let image = UIImage(data: data!)!
                                        
                                        userBaseData.image = image
                                        
                                        complitionHandler(userBaseData)
                                    }
                                }
                            }
                            
                            //
                        }
                    }
            }
        }
        
        
    }
    
    
    static func updateLikesInDB(userId: String, otherUserId: String, complitionHandler: @escaping (Bool) -> Void) {
        
        
        
        //get Likes from user
        getUserBaseDataFromDB(userId) { userBaseData1 in
            var likes = userBaseData1.likes
            likes! += 1
            
            //update his likes
            var myDict = [String : Any]()
            myDict["likes"] = likes
            
            Firestore.firestore().collection("userBaseData").document(userId).updateData(myDict) { err in
                if err != nil {
                    //                    print(err?.localizedDescription)
                    complitionHandler(false)
                    return
                } else {
                    
                    //update dislikes otherUser
                    //get Dislikes from otherUser
                    getUserBaseDataFromDB(otherUserId) { userBaseData2 in
                        var dislikes = userBaseData2.dislikes
                        dislikes! += 1
                        
                        //update his likes
                        var myDict2 = [String : Any]()
                        myDict2["dislikes"] = dislikes
                        
                        Firestore.firestore().collection("userBaseData").document(otherUserId).updateData(myDict2) { err in
                            if err != nil {
                                //                                print(err?.localizedDescription)
                                complitionHandler(false)
                                return
                            } else {
                                
                                //update dislikes otherUser
                                complitionHandler(true)
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        
        
    }
}
