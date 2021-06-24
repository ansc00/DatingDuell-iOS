//
//  LoginViewController.swift
//  DatingDuell
//
//  Created by tk on 26.05.21.
//

//Manage the register and login to Firebase

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var stackViewAreaScreen: UIStackView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var button: RoundedButton!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var passwordPV: UIProgressView!
    
    var showSignUpScreen = false
    //var headerTitle: String?
    
    //Firebase Auth state change listner
    var handleAuthStateDidChange: AuthStateDidChangeListenerHandle?
    var user: User?
    
    var activityIndicator: MyActivityInidicator?
    var showOnboarding: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view./
         updateUI()
        emailTF.delegate = self
        passwordTF.delegate = self
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordPV.setProgress(0, animated: false)

        activityIndicator = MyActivityInidicator(addToView: self.view)
         
        let uiTapGesture = UITapGestureRecognizer()
        self.stackViewAreaScreen.addGestureRecognizer(uiTapGesture)
        uiTapGesture.addTarget(self, action: #selector(dismissKeyboard(_:)))
         
//        let userEmailAdress = Auth.auth().currentUser?.email
//        showOnboarding = UserDefaults.standard.bool(forKey: userEmailAdress!) == true ? true : false //default true
//        
        
        
    }
    
    //if user already sign in > transition to next Screen // only after view DID Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if Auth.auth().currentUser != nil  {
            Database.getUserById(id: Auth.auth().currentUser!.uid) { user in
                if user != nil {
                    self.user = user
                    print("Logged Useremail: " + user!.email! )
                    Database.isUserBaseDataAvailable(userId: user!.id!) { isAvailable in
                       
                        self.showOnboarding = !isAvailable
                        self.performTransition()
                    }
                } else {
                    //nothing cause user just not logged in
                }
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleAuthStateDidChange = Auth.auth().addStateDidChangeListener { (auth, user)in
            //
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if handleAuthStateDidChange != nil {
            Auth.auth().removeStateDidChangeListener(handleAuthStateDidChange!)
        }
    }
    
   

    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        let isInputValid = isEmailAddressValid() && isPasswordValid()
        
        if isInputValid {
            emailTF.endEditing(true)
            passwordTF.endEditing(true)
            
            if showSignUpScreen {
                activityIndicator?.showActivityIndicator()
                //signUp User
                signUpUser()
            }else {
                activityIndicator?.showActivityIndicator()
                //sign in User
                signInUser()
            }
            
           
        } else {
            //email and/or password failed
            //show alert dialog
            showAlertDialog(title: "Check input data", message: "Please check your E-Mail and password")
        }
        
    }
    
    @objc func dismissKeyboard(_ sender: UIGestureRecognizer){
        emailTF.endEditing(true)
        passwordTF.endEditing(true)
    }
    
    func performTransition() -> Void {
        if self.showOnboarding {
            self.performSegue(withIdentifier: K.loginToBaseDataVCIdentifier, sender: nil)
        } else {
            self.performSegue(withIdentifier: K.loginToDuellVCidentifier, sender: nil)
        }
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.loginToDuellVCidentifier {
//            let vcDest = segue.destination as! DuellViewController
//            vcDest.user = self.user
//            print(user?.email)
//        }
//    }
    
    func signUpUser() {
        //create User
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (authDataResult, error) in
            if error != nil {
                let message = error!.localizedDescription as String
                self.showAlertDialog(title: "Error", message: message)
                self.activityIndicator?.hideActivityIndicator()
            } else {
              //no error
                if let user = authDataResult?.user {
                    
                    //Create USER
                    let myUser = User(id: user.uid,
                                      email: user.email,
                                      role: "User")
                    //add User to DB
                    Database.createNewUserInFirebaseDB(user: myUser, complitionHandler: { (success) -> Void in
                        
                        if (success){
                            //User added succesful to db
                            //signIN user
                            self.signInUser()
                        } else {
                          //something went wrong
                            self.activityIndicator?.hideActivityIndicator()
                        }
                        
                    })
                    
                }
            }
        }
    }
    
    func signInUser() {
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (authDataResult, error) in
            if error != nil {
                let message = error!.localizedDescription as String
                self.showAlertDialog(title: "Error", message: message)
                self.activityIndicator?.hideActivityIndicator()
            } else {
              //no error
                if let user = authDataResult?.user {
                    
                    //get UserData from Database and go to next Screen
                    Database.getUserById(id: user.uid) { user in
                        self.user = user
                        print(user?.email)
                        self.activityIndicator?.hideActivityIndicator()
                        Database.isUserBaseDataAvailable(userId: user!.id!) { isAvailable in
                           
                            self.showOnboarding = !isAvailable
                            self.performTransition()
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    
    func showAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            //nothing
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func updateUI(){
        if showSignUpScreen {
            //signUp Screen
            button.setTitle("Create Account", for: .normal)
            button.backgroundColor = UIColor.red
            self.title = "Sign-Up"
        } else {
            //login Screen
            button.setTitle("Login", for: .normal)
            button.backgroundColor = UIColor(red: 89 / 255, green: 204 / 255, blue: 253 / 255, alpha: 1.0)
            self.title = "Login"
        }
    }
    
    func isEmailAddressValid() -> Bool {
        var isValid = false
        
        if emailTF.hasText {
            //data is not nil, not empty
            //validate
            let trimmedChars = emailTF.text!.trimmingCharacters(in: .whitespaces)
            let indexAtSign = trimmedChars.firstIndex(of: "@") //returns Optional(Swift.String.Index(_rawBits: 262400)) OR nil if not available
            let indexAtDot = trimmedChars.firstIndex(of: ".")
            
            //min. 6 letters + AT-Sign + DOT
            if emailTF.text!.count >= 6  && indexAtSign != nil && indexAtDot != nil { //a@w.co
                isValid = true
            } else {
                isValid = false
            }
            
        } else {
           isValid = false
        }
        
        return isValid
    }
    
    
    
    func isPasswordValid() -> Bool {
        var isValid = false
        
        if passwordTF.hasText {
            
            if passwordTF.text!.count >= 6 {
                isValid =  true
            } else {
                isValid = false
            }
            
        } else {
            isValid =  false
        }
        
        return isValid
    }

    

    
    
}


    


//MARK: UITExtFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField.restorationIdentifier == K.restorationIdentifierEmail {
              
        } else if textField.restorationIdentifier == K.restorationIdentifierPassword {
          
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if  textField.restorationIdentifier == K.restorationIdentifierEmail {
              
        } else if textField.restorationIdentifier == K.restorationIdentifierPassword {
          
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if  textField.restorationIdentifier == K.restorationIdentifierEmail {
              
        } else if textField.restorationIdentifier == K.restorationIdentifierPassword {
           
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if  textField.restorationIdentifier == K.restorationIdentifierEmail {
              
        } else if textField.restorationIdentifier == K.restorationIdentifierPassword {
          
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      if  textField.restorationIdentifier == K.restorationIdentifierEmail {
            
      } else if textField.restorationIdentifier == K.restorationIdentifierPassword {
        
       
      }
    }
    
    //called by every entry on passwordTF
    @objc final private func textFieldDidChange(_ textField: UITextField){
        
            checkAndUpdateProgressView()
        
    }
    
    private func checkAndUpdateProgressView(){
        //min 6 letters
        //with 1 Big letter
        //Number
        //other Signs
        // red = unsafe, //yellow = ok // green = safe (all 4)
        //var hasMinLetters = false
//        var hasOneBigLetter = false
//        var hasNumber = false
//        var hasOtherSign = false
        var boolArray = Array(repeating: false, count: 3)
//        boolArray.append(false)
//        boolArray.append(false)
//        boolArray.append(false)
        
        if passwordTF.hasText {
            
            let passwordText = passwordTF.text!
            
        
            //hasOneBigLetter
            var matched = CheckRegex.matches(for: "[A-Z]", in: passwordText)
//            print(matched)
            if matched.count >= 1 {
                boolArray[0] = true
            } else {
                boolArray[0] = false
            }
            
            //hasNumber
            matched = CheckRegex.matches(for: "[0-9]", in: passwordText)
//            print(matched)
            if matched.count >= 1 {
                boolArray[1] = true
            } else {
                boolArray[1] = false
            }
            
            //hasOtherSign
            matched = CheckRegex.matches(for: "[!\"§$%&/()=?]", in: passwordText)
//            print(matched)
            if matched.count >= 1 {
                boolArray[2] = true
            } else {
                boolArray[2] = false
            }
        }
        
        //set progress
        var value = passwordTF.text!.count
        if passwordTF.text!.count > 6 {
            value = 6
        }
        
        
        let progValue = (100.0 / 6 *  Float(value) ) / 100.0 //6.0 > 1.0,  3.0 > 0.5,  0.0 > 0.0
        passwordPV.setProgress(progValue, animated: true)
       
        
        
        //set color
        //minLetts = must have
        //others optional
        
        var count = 0
        for val in boolArray {
            if val == true {
                count += 1
            }
        }
//        print(count)
//        print(boolArray[0])
//        print(boolArray[1])
//        print(boolArray[2])
        
        //change color //Safe // unsafe// ok
        switch count {
        case 0: passwordPV.tintColor = UIColor.red
            break
        case 1: passwordPV.tintColor = UIColor.orange
            break
        case 2: passwordPV.tintColor = UIColor.yellow
            break
        case 3: passwordPV.tintColor = UIColor.green
            break
            
        default: passwordPV.tintColor = UIColor.red
            break
                
        }
        
    }
    
  
    
    
}
