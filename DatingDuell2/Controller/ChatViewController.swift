//
//  ChatViewController.swift
//  DatingDuell2
//
//  Created by tk on 15.06.21.
//

//ChatViewController shows all chatpartners we have written with

import UIKit
import Firebase

//CELL
class ChatUserBaseDataCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
}

//CONTROLLER
class ChatViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
 
    
    
    
    @IBOutlet weak var chatPartnerSelectionTV: UITableView!
    var currentIndexPath: IndexPath?
    
    let mGroup = DispatchGroup()
    
    var allUserBaseData = [UserBaseData]()
//    var allMessageIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  
        chatPartnerSelectionTV.delegate = self
        chatPartnerSelectionTV.dataSource = self
        
        chatPartnerSelectionTV.rowHeight = 80
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
    
    
    func fetchData(){
        print("fetchDATA")
        let myUserId = Auth.auth().currentUser!.uid
        Database.getMyChatPartnersIDsFromDB(fromThisUserId: myUserId) { (userBaseDataIds) in
//            print(userBaseDataIds)
            self.allUserBaseData.removeAll()

            for id in userBaseDataIds {
                self.mGroup.enter()
                Database.getUserBaseDataFromDB(id) { userBaseData in
                    self.allUserBaseData.append(userBaseData)
                    self.mGroup.leave()
                    print("leave aufruf")
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                print("This is run on a background queue")
                self.mGroup.wait()
                
                self.allUserBaseData =  self.allUserBaseData.sorted(by: { $0.name! < $1.name! })
                
                self.mGroup.notify(queue: DispatchQueue.main) {

                    print("Finished all requests.")
                    DispatchQueue.main.async {
                        self.chatPartnerSelectionTV.reloadData()
                    }
                    
                }
            }
            
            print("main is DONE")
            
        }
    }
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUserBaseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userBaseDataCell", for: indexPath) as! ChatUserBaseDataCell
        
        cell.myImageView.image = self.allUserBaseData[indexPath.row].image
        cell.myLabel.text = self.allUserBaseData[indexPath.row].name
        
        
        
        cell.myImageView.layer.cornerRadius = 10
        cell.myImageView.clipsToBounds = true
        cell.myImageView.layer.masksToBounds = true
        cell.myImageView.contentMode = .scaleAspectFill
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndexPath = indexPath
//        print(currentIndexPath?.row)
        
        self.performSegue(withIdentifier: K.chatPartnerSelectionToChatMessagesTVCIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.chatPartnerSelectionToChatMessagesTVCIdentifier {
            let VC = segue.destination as! ChatMessageViewController
            
            VC.chatPartnerUserBaseData = self.allUserBaseData[self.currentIndexPath!.row]
//            VC.allMessageIds = self.allMessageIds
            
            
        }
    }
    
    

}
