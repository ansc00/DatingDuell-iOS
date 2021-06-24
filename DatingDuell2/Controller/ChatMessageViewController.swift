//
//  ChatMessagesTableViewController.swift
//  DatingDuell2
//
//  Created by tk on 16.06.21.
//
//Displays the dialog between two users and allows to chat with each other

import UIKit
import Firebase

class ChatMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatPartnerUserBaseData: UserBaseData?
     
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField! //TODO
    @IBOutlet weak var sendButton: UIButton! //TO DO
    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
//        tableView.backgroundColor = .green
        title = chatPartnerUserBaseData?.name
        
//        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    func fetchData(){
        let myUserId = Auth.auth().currentUser?.uid
        Database.getAllMessages(fromUserWithUID: myUserId!, toUserWithUID: self.chatPartnerUserBaseData!.id!) { messages in
            self.messages = messages
            
            Database.getAllMessages(fromUserWithUID: self.chatPartnerUserBaseData!.id!, toUserWithUID: myUserId!) { messages2 in
                for mess in messages2 {
                    self.messages.append(mess)
                }
                
                //ordnen nach zeitpunkt
                self.messages = self.messages.sorted(by: {$0.timestamp! < $1.timestamp! })
                 
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell

        // Configure the cell...
        let message = self.messages[indexPath.row]
        cell.myLabel.text = message.body
        cell.myTimeLabel.text = Calculate.getActualDateAndTime(timeStamp: Double(message.timestamp!))
        
       
        
        if message.fromUserWithUID == self.chatPartnerUserBaseData?.id {
            cell.myImageView?.image = self.chatPartnerUserBaseData?.image
//            cell.imageView?.isHidden = false
        } else {
//            cell.imageView?.isHidden = true
            cell.myImageView?.image = UIImage(named: "meProfileImage")
            
        }
        cell.myImageView!.layer.cornerRadius = cell.myImageView!.frame.height / 2
        cell.myImageView!.layer.masksToBounds = true
        cell.myImageView?.contentMode = .scaleAspectFill
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
