//
//  ProfileViewController.swift
//  DatingDuell
//
//  Created by tk on 08.06.21.
// control + i = format code


//ProfileViewController showing personal information and allow user to sign out
import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var labelBackgroundView: UIView?
    var myLabelView: UILabel?
    var myImageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
        loadData()
    }
    
    func setupViews(){
        labelBackgroundView = UIView()
        labelBackgroundView!.frame = CGRect(x: 40, y: 100, width: self.view.frame.width - 70, height: 200)
        view.addSubview(labelBackgroundView!)
        labelBackgroundView!.layer.cornerRadius = 10
        labelBackgroundView!.layer.masksToBounds = true
        
        myLabelView = UILabel(frame: CGRect(x: 5, y: 5, width:  labelBackgroundView!.frame.width - 10, height: labelBackgroundView!.frame.height - 10))
        labelBackgroundView!.addSubview(myLabelView!)
        myLabelView!.numberOfLines = 0
        
        
        myImageView = UIImageView()
        self.view.addSubview(myImageView!)
        myImageView!.frame = CGRect(x: 40, y: labelBackgroundView!.frame.maxY + 5, width: 200  , height: 200)
        
        myImageView?.layer.cornerRadius = 10
        myImageView?.layer.masksToBounds = true
        myImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTappedGesture(_:))))
        myImageView?.isUserInteractionEnabled = true
        
    }
    
    func loadData(){
        Database.getUserBaseDataFromDB(Auth.auth().currentUser!.uid) { userBaseData in
            
            DispatchQueue.main.async {
                self.myLabelView!.text = "id: " +  userBaseData.id! +
                    "\nemail: " + userBaseData.email! +
                    "\nname: " + userBaseData.name! +
                    "\ngender: " + userBaseData.gender! +
                    "\nBirthday: " + userBaseData.birthday! +
                    "\nSearchedGender: " + userBaseData.searchedGender! +
                    "\nlat: " + String( userBaseData.myCoordinate.lat!) +
                    "\nlong: " + String( userBaseData.myCoordinate.lon!)
                
                self.myImageView!.image = userBaseData.image
                
                self.labelBackgroundView!.backgroundColor = .white
                
            }
        }
    }
    
    @objc func handleImageTappedGesture(_ sender: UITapGestureRecognizer){
        MyAnimations.labelsLeftAndUpAnimation(titleView: self.myLabelView!, bodyView: self.myImageView!)
        MyAnimations.fadeOut(labelBackgroundView!)
        
    }
    

   
    @IBAction func signOutButtonClicked(_ sender: Any) {
        do {
         try  Auth.auth().signOut()
//            self.dismiss(animated: true, completion: nil)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
    
}
