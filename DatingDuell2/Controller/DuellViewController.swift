//
//  DuellViewController.swift
//  DatingDuell
//
//  Created by tk on 03.06.21.
//

//Main page in the Application where two people are shown and the user can decide one to vote

import UIKit
import Firebase
import Dispatch

class DuellViewController: UIViewController {
    
    let window = UIApplication.shared.windows[0]
    var topPadding: CGFloat?
    var userBaseData: UserBaseData?
    
    var yDistanceFromTop: CGFloat?
    
    var userBaseDataBattle1: UserBaseData?
    var userBaseDataBattle2: UserBaseData?
    
    var otherUserBaseData: [UserBaseData]?
    
    
    var userDuellViews = [UserDuellView]()
    
    var loadNextBattleUser1: UserBaseData?
    var loadNextBattleUser2: UserBaseData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateYDistanceFromTop()
        loadData()
    }
    
  
    
    func calculateYDistanceFromTop(){
        topPadding = window.safeAreaInsets.top
        yDistanceFromTop = topPadding! + self.navigationController!.navigationBar.frame.height
    }
    
    
    
    func loadData(){
        Database.getUserBaseDataFromDB( Auth.auth().currentUser!.uid) { myUserBaseData in
            //load own data
            self.userBaseData = myUserBaseData
            self.loadNextRound()
        }
    }
    
    
    func loadNextRound(){
        self.getNextTwoPlayer { success in
            if success {
                print("xxxx")
                self.showDuellMatch()
                
                self.loadUpNextTwoUsersInBackground { success in
                    if success {
                        //nothing jsut rdy
                    } else {
                        
                    }
                }
            } else {
                //
            }
        }
    }
    
    func changeNextUserPositions(){
        self.userBaseDataBattle1 = self.loadNextBattleUser1
        self.userBaseDataBattle2 = self.loadNextBattleUser2
        self.showDuellMatch()
        
        self.loadUpNextTwoUsersInBackground { success in
            if success {
                //nothing jsut rdy
            } else {
                
            }
        }
    }
    
    func loadUpNextTwoUsersInBackground(completion: @escaping (Bool)->() ) {
        
        var dontShowUserWithThisUserCounter = [self.userBaseData!.userCounter!]
        print(dontShowUserWithThisUserCounter)
        
        let myGroup: DispatchGroup = DispatchGroup()
        
        let queue = DispatchQueue.global()
        print("loadUpNextTwoUsersInBackground startet ")
        myGroup.enter()
        queue.async(group: myGroup) {
            Database.getOneUserFromDBRandomly( dontShowUserWithThisUserCounter, wishedGender: self.userBaseData!.searchedGender!)  { userBaseData1 in
                self.loadNextBattleUser1 = userBaseData1 //SET THEM HERE
                print("loadNextBattleUser2 id1: \(userBaseData1.id)")
                dontShowUserWithThisUserCounter.append(userBaseData1.userCounter!)
                
                Database.getOneUserFromDBRandomly( dontShowUserWithThisUserCounter, wishedGender: self.userBaseData!.searchedGender! ) { userBaseData2 in
                    self.loadNextBattleUser2 = userBaseData2 //SET THEM HERE
                    print("loadNextBattleUser2 id2: \(userBaseData2.id)")
                    dontShowUserWithThisUserCounter.removeAll()
                    myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) { // this here is the key
            completion(true)
        }
    }
    
    
    
    
    func getNextTwoPlayer(completion: @escaping (Bool)->() ) {
        
        var dontShowUserWithThisUserCounter = [self.userBaseData!.userCounter!]
        print(dontShowUserWithThisUserCounter)
        
        let myGroup: DispatchGroup = DispatchGroup()
        
        let queue = DispatchQueue.global()
        print("REPEAT DURCHLÄUFE ")
        myGroup.enter()
        queue.async(group: myGroup) {
            Database.getOneUserFromDBRandomly( dontShowUserWithThisUserCounter, wishedGender: self.userBaseData!.searchedGender!) { userBaseData1 in
                self.userBaseDataBattle1 = userBaseData1
//                print("REPEAT DURCHLÄUFE id1: \(userBaseData1.id)")
                dontShowUserWithThisUserCounter.append(userBaseData1.userCounter!)
                
                Database.getOneUserFromDBRandomly( dontShowUserWithThisUserCounter, wishedGender: self.userBaseData!.searchedGender!) { userBaseData2 in
                    self.userBaseDataBattle2 = userBaseData2
//                    print("REPEAT DURCHLÄUFE id2: \(userBaseData2.id)")
                    dontShowUserWithThisUserCounter.removeAll()
                    myGroup.leave()
                }
            }
        }
        
        //        print("start waiting")
        //        myGroup.wait() //blocking the main queue and myGroup.leave NEVER cant be reached!
        //        print("end waiting")
        
        myGroup.notify(queue: DispatchQueue.main) { // this here is the key
            completion(true)
        }
    }
    
    
    
    
    func showDuellMatch(){
        
        var otherUserBaseData = [UserBaseData]()
        guard let ubdata1 = self.userBaseDataBattle1 else { return }
        guard let ubdata2 = self.userBaseDataBattle2 else { return }
        otherUserBaseData.append(ubdata1)
        otherUserBaseData.append(ubdata2)
        
        //        print("otherUserBaseData COUnt: \(otherUserBaseData.count)")
        
        self.userDuellViews.removeAll()
        let userDuellView = UserDuellView(frame: CGRect(x: 0, y:  self.yDistanceFromTop! + 10, width: self.view.frame.width, height: 200))
        userDuellView.imageView.tag = 1 //AUFPASSEN !!! auf was man TAG setzt
        userDuellView.sendMessageIV.tag = 1
        userDuellView.sendMessageButton.tag = 1
        let userDuellView2 = UserDuellView(frame: CGRect(x: 0, y:  userDuellView.frame.height + 100 , width: self.view.frame.width, height: 200))
        userDuellView2.imageView.tag = 2
        userDuellView2.sendMessageIV.tag = 2
        userDuellView2.sendMessageButton.tag = 2
        self.view.addSubview(userDuellView)
        self.view.addSubview(userDuellView2)
        self.userDuellViews.append(userDuellView)
        self.userDuellViews.append(userDuellView2)
        
        //        print("myTAG userDuellViews[0]: \(self.userDuellViews[0].tag)")
        
        var count = 0
        for userDuellView in self.userDuellViews {
            
            DispatchQueue.main.async {
                print("DURCHLAUF")
                
                userDuellView.nameLabel.text = otherUserBaseData[count].name
                userDuellView.ageLabel.text = String(Calculate.calculateAge(dateString: otherUserBaseData[count].birthday!))
                userDuellView.distanceLabel.text = Calculate.distanceInKmBetweenEarthCoordinates(lat1: self.userBaseData!.myCoordinate.lat!,
                                                                                                 lon1: self.userBaseData!.myCoordinate.lon!,
                                                                                                 lat2: otherUserBaseData[count].myCoordinate.lat!,
                                                                                                 lon2: otherUserBaseData[count].myCoordinate.lon!) + " km"
                userDuellView.procentualLikesLabel.text = Calculate.procentualLikes(likes: otherUserBaseData[count].likes!,
                                                                                    dislikes: otherUserBaseData[count].dislikes!)
                userDuellView.imageView.image = otherUserBaseData[count].image
                //                userDuellView.backgroundColor = UIColor.yellow
                
                userDuellView.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleUserTappedOnImage(_:))))
                userDuellView.imageView.isUserInteractionEnabled = true
                //                    print("myTAG userDuellViews[0]: \(self.userDuellViews[0].tag)")
                
                //set rounded corners
                userDuellView.imageView.layer.cornerRadius = 8
                userDuellView.imageView.layer.masksToBounds = true
                
                userDuellView.sendMessageIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleMessageButtonTapped(_:))))
                userDuellView.sendMessageIV.isUserInteractionEnabled = true
                
                //send message button
                userDuellView.sendMessageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleMessageButtonTapped(_:))))
                count += 1
                
            }
        }
    }
    
    @objc func handleMessageButtonTapped(_ sender: UITapGestureRecognizer){
        print("send a message / show input view TAG: \(sender.view?.tag)")
        // push view controller but animate modally
        //            let storyBoard: UIStoryboard = UIStoryboard(name: "myStoryBoard", bundle: nil)
        //            let vc = storyBoard.instantiateViewController(withIdentifier: "myViewControllerIdentifier") as! MyViewController
        let vc = TypeNewMessageInViewController()
        vc.myUserBaseData =  self.userBaseData
        
        if sender.view?.tag == 1 {
            vc.otherUserBaseData = self.userBaseDataBattle1
        } else if sender.view?.tag == 2 {
            vc.otherUserBaseData = self.userBaseDataBattle2
        }
        
        vc.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: vc, action: #selector(vc.closeView))
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: vc, action: nil)
        
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @objc func handleUserTappedOnImage(_ sender: UITapGestureRecognizer){
        let clickedViewTag = sender.view!.tag
        //        print("myTAG userDuellViews[0]: \(self.userDuellViews[0].tag)")
        print(clickedViewTag)
        if clickedViewTag == 1 {
            //            print(self.userBaseDataBattle1)
            Database.updateLikesInDB(userId: self.userBaseDataBattle1!.id!, otherUserId: self.userBaseDataBattle2!.id!) { success in
                print(success)
                if success {
                    //show next DUell
                    //remove userDuellView elemente and show next
                    self.removeDuellViews()
                    self.changeNextUserPositions()
                } else {
                    
                }
            }
        } else if clickedViewTag == 2 {
            //            print(self.userBaseDataBattle2)
            Database.updateLikesInDB(userId: self.userBaseDataBattle2!.id!, otherUserId: self.userBaseDataBattle1!.id!) { success in
                print(success)
                if success {
                    //show next duell
                    self.removeDuellViews()
                    self.changeNextUserPositions()
                } else {
                    
                }
            }
        }
    }
    
    func removeDuellViews(){
        for myView in self.userDuellViews {
            myView.removeFromSuperview()
        }
    }
    
}
