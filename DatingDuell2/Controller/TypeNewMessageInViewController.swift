//
//  TypeNewMessageInViewController.swift
//  DatingDuell2
//
//  Created by tk on 15.06.21.
//

//Pop up that allows to send a message to other user

import UIKit

class TypeNewMessageInViewController: UIViewController {

    var myUserBaseData: UserBaseData?
    var otherUserBaseData: UserBaseData?
    
    var nameLabel: UILabel = {
        let name = UILabel()
        
       
        return name
    }()
    
    var imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.clipsToBounds = true
        
        return imageV
    }()
    
    var textField: UITextField = {
        let text = UITextField()
        text.placeholder = "send a message"
        
        return text
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("send", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        setupLayout()
    }
    
    func setupLayout(){
        imageView.image = otherUserBaseData?.image
        imageView.frame = CGRect(x: 10, y: 150, width: 100, height: 100)
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .gray
        view.addSubview(imageView)
        
        nameLabel.text = otherUserBaseData!.name! + ", \(Calculate.calculateAge(dateString: otherUserBaseData!.birthday! ))"
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 10, y: imageView.frame.maxY + 10,  width: nameLabel.frame.width + 5, height: 50)
//        nameLabel.backgroundColor = .red
        view.addSubview(nameLabel)
        
       
        
        textField.frame = CGRect(x: 10 , y:  nameLabel.frame.maxY + 10, width: self.view.frame.width - 120 , height: 40)
//        textField.backgroundColor = .purple
        view.addSubview(textField)
        
        sendButton.frame = CGRect(x: textField.frame.width + 10, y: nameLabel.frame.maxY + 10 , width: 100, height: 40)
        sendButton.backgroundColor = .blue
        sendButton.layer.cornerRadius = 4
        sendButton.addTarget(self, action: #selector(handleSendButtonClicked(_:)), for: .touchUpInside)
        view.addSubview(sendButton)
    }

    
    @objc func handleSendButtonClicked(_ sender: UIButton) {
        if sender.currentTitle == "send" {
            guard let text = textField.text else { return }
            Database.saveMessageToDB(fromId: self.myUserBaseData!.id!, toId: self.otherUserBaseData!.id!, text ) { success in
                if success {
                    self.closeView()
                } else {
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func closeView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }

}
