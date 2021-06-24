//
//  ViewController.swift
//  DatingDuell
//
//  Created by tk on 20.05.21.
//

//Start Screen: Allow the user to sign-up or sign-in

import UIKit

import Firebase
import GoogleSignIn

class StartViewController: UIViewController {

    
    @IBOutlet weak var signUpButton: RoundedButton!
    @IBOutlet weak var loginButton: RoundedButton!
    
    var splashScreenIV: UIImageView?
    var wasSignUpButtonClicked = false
    var hasPerformedSplashAnimation = false
 
    @IBOutlet weak var signInButtonsStackView: UIStackView!
    var showOnboarding: Bool = true
    var user: User?
    
    var cAEmitterLayer: CAEmitterLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view./
        setupButtons()
        
        
        //Google Sign In
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self

//        do {
//
//            try GIDSignIn.sharedInstance().signOut()
//            try Auth.auth().signOut()
//
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//        }
        print(Auth.auth().currentUser)
        
//        let userEmailAdress = Auth.auth().currentUser?.email
//        UserDefaults.standard.setValue(true, forKey: userEmailAdress!)
        
        
//        self.showOnboarding  = UserDefaults.standard.bool(forKey: userEmailAdress!)  //default true
//        print(self.showOnboarding)
//        self.createClickAnimation()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasPerformedSplashAnimation {
            performSplashScreenAnimation()
            hasPerformedSplashAnimation = true
        }
        
         
            if Auth.auth().currentUser != nil  {
                Database.getUserById(id: Auth.auth().currentUser!.uid) { user in
                    if user != nil {
                        print("Logged Useremail: " + user!.email! )
                        self.user = user
                        Database.isUserBaseDataAvailable(userId: user!.id!) { isAvailable in
                           print(isAvailable)
                            self.showOnboarding = !isAvailable
                            self.performTransition()
                        }
                        
                    } else {
                        //nothing cause user just not logged in
                    }
                }
                
            }
         
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimation()
    }
  
    
    
    @IBAction func signUpOrLoginButtonClicked(_ sender: RoundedButton) {
        let signUpButtonTitle = NSLocalizedString("LoginViewController.Action.SignUp", comment: "Sign-Up Button")
        
        let loginButtonTitle = NSLocalizedString("LoginViewController.Action.SwitchToLogin", comment: "Login Button")
        
       
        if sender.currentTitle == signUpButtonTitle {
//            print("case Sign UP ")
            wasSignUpButtonClicked = true
        } else if sender.currentTitle == loginButtonTitle {
//            print("case LOGIN")
            wasSignUpButtonClicked = false
        }
        performSegue(withIdentifier: K.startToLoginVCIdentifier, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.startToLoginVCIdentifier {
            
            let navController = segue.destination as! UINavigationController
            let destVC = navController.topViewController as! LoginViewController
            destVC.showSignUpScreen = wasSignUpButtonClicked
           
            
        }
    }
    
    
    //perform an splashScreen animation
    func performSplashScreenAnimation(){
        
        //get image
        let image = UIImage(named: "DatingDuellBild2.png")
        let iv = UIImageView(image: image!)
        //set Rectangle frame
        iv.frame = CGRect(x: 0, y: self.view.frame.height / 50, width: self.view.frame.width, height: self.view.frame.height)
        iv.contentMode = .scaleAspectFit
         
        splashScreenIV = iv
        //Add image to view
        self.view.addSubview(splashScreenIV!)
        
        //start animation
        UIView.animate(withDuration: 2.0) {
            self.splashScreenIV?.alpha = CGFloat(Float(0))
            self.splashScreenIV?.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        }
    }
    
    
    //Setup the extern sign-up buttons
    func setupButtons() {
        
        //setup Title
        let signUpButtonTitle = NSLocalizedString("LoginViewController.Action.SignUp", comment: "Sign-Up Button")
        signUpButton.setTitle(signUpButtonTitle, for: .normal)
        let loginButtonTitle = NSLocalizedString("LoginViewController.Action.SwitchToLogin", comment: "Login Button")
        loginButton.setTitle(loginButtonTitle, for: .normal)
        
        let appleLoginButtonTitle = NSLocalizedString("LoginViewController.Action.SignInWithApple", comment: "Apple Button")
        let gmailLoginButtonTitle = NSLocalizedString("LoginViewController.Action.SignInWithGmail", comment: "Gmail Button")
        let facebookLoginButtonTitle = NSLocalizedString("LoginViewController.Action.SignInWithFacebook", comment: "Facebook Button")
        
        
        var appleLogoImage: UIImage?
        if #available(iOS 13.0, *) {
            appleLogoImage = UIImage(systemName: "applelogo")
        } else {
            // Fallback on earlier versions
            appleLogoImage = UIImage(named: "apple")
        }
        
        let buttonWidth = 280
        let buttonHeight = 50
        let yDistanceBetween = 8
        let xPos = (Int(view.frame.size.width) / 2) - (buttonWidth / 2)
        
        let appleLoginButton = RoundedIconTextButton(frame: CGRect(x: xPos, y: 0, width: buttonWidth, height: buttonHeight))
        signInButtonsStackView.addSubview(appleLoginButton)
        
        //google SignIN BUtton
        let gmailLoginButton = RoundedIconTextButton(frame: CGRect(x: xPos, y: Int(appleLoginButton.frame.maxY) + yDistanceBetween, width: buttonWidth, height: buttonHeight))
        signInButtonsStackView.addSubview(gmailLoginButton)
//        let gmailLoginButton = GIDSignInButton(frame: CGRect(x: xPos, y: Int(appleLoginButton.frame.maxY) + yDistanceBetween, width: buttonWidth, height: buttonHeight))
//        signInButtonsStackView.addSubview(gmailLoginButton)
//        gmailLoginButton.layer.cornerRadius = 20
//        gmailLoginButton.layer.borderWidth = 1
//        gmailLoginButton.layer.borderColor = UIColor.black.cgColor
//        gmailLoginButton.clipsToBounds = true
        
        let facebookLoginButton = RoundedIconTextButton(frame: CGRect(x: xPos, y: Int(gmailLoginButton.frame.maxY) + yDistanceBetween, width: buttonWidth, height: buttonHeight))
        signInButtonsStackView.addSubview(facebookLoginButton)
        
         
        appleLoginButton.configure(with: IconTextButtonViewModel(
            labelText: appleLoginButtonTitle,
            image: appleLogoImage
        ))
        
        gmailLoginButton.configure(with: IconTextButtonViewModel(
            labelText: gmailLoginButtonTitle,
            image: UIImage(named: "google_svg")
        ))
        facebookLoginButton.configure(with: IconTextButtonViewModel(
            labelText: facebookLoginButtonTitle,
            image: UIImage(named: "fb")
        ))
        
        //addActions
        appleLoginButton.addTarget(self, action: #selector(loginWithApple(_:)), for: .touchUpInside)
        gmailLoginButton.addTarget(self, action: #selector(loginWithGmail(_:)), for: .touchUpInside)
        facebookLoginButton.addTarget(self, action: #selector(loginWithFacebook(_:)), for: .touchUpInside)
        
    }
    
    @objc func loginWithApple(_ sender: UIButton){
        showMessageDialog("Ups", "not implemented")
        stopAnimation()
        createAnimation(imageName: "apple", xPos: sender.center.x, yPos: sender.center.y)
        
    }

    @objc func loginWithGmail(_ sender: UIButton){
        stopAnimation()
        createAnimation(imageName: "google_svg", xPos: sender.center.x, yPos: sender.center.y)
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func loginWithFacebook(_ sender: UIButton){
        showMessageDialog("Ups", "not implemented")
        stopAnimation()
        createAnimation(imageName: "fb", xPos: sender.center.x, yPos: sender.center.y)
    }
    
   
    
    func showMessageDialog(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

extension StartViewController: GIDSignInDelegate {
    
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      //handle sign-in errors
      if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
          } else {
          print("error signing into Google \(error.localizedDescription)")
          }
      return
      }
      
    
      // Get credential object using Google ID token and Google access token
      guard let authentication = user.authentication else { return }

      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                      accessToken: authentication.accessToken)

        
      // Authenticate with Firebase using the credential object
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
              print("authentication error \(error.localizedDescription)")
            self.showMessageDialog("Error", "Something went wrong! " + error.localizedDescription)
            return
          }
        
        print(authResult?.user.email)
        
        //authResult.user is available!
        
        //check if user existins in DB
        //if not > create new user and log in
        //if exists > get user and log in
        Database.getUserById(id: authResult!.user.uid) { user in
            if user == nil { //user doesnt exists in DB
                //create new User and save in DB
                let myUser = User(id: authResult!.user.uid, email: authResult!.user.email, role: "User") //create user
                Database.createNewUserInFirebaseDB(user: myUser) { success in //add to DB
                    if success {
                        self.user = myUser
                        self.performTransition()
                       
                    } else {
                        self.showMessageDialog("Error", "Something went wrong!")
                    }
                }
            } else { //user exists
                self.user = user
                Database.isUserBaseDataAvailable(userId: user!.id!) { isAvailable in
                   
                    self.showOnboarding = !isAvailable
                    self.performTransition()
                }
            }
        }
        
        
      }
  }
    
    func performTransition() -> Void {
        if self.showOnboarding {
            self.performSegue(withIdentifier: K.startToBaseDataVCIdentifier, sender: nil)
        } else {
            self.performSegue(withIdentifier: K.startToDuellVCidentifier, sender: nil)
        }
    }
    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
    
    func createAnimation(imageName: String, xPos: CGFloat, yPos: CGFloat){

        self.cAEmitterLayer = CAEmitterLayer()
        cAEmitterLayer!.emitterPosition = CGPoint(x: xPos,
                                        y: yPos)
        
        let colors: [UIColor] = [
            .systemBlue,
            .systemRed,
            .systemPink,
            .systemGreen
        ]
            
        
        
        let cells: [CAEmitterCell] = colors.compactMap {
            let cell = CAEmitterCell()
            cell.scale = 0.05
            cell.emissionRange =  .pi * 2
            cell.lifetime = 30
            cell.birthRate = 10
            cell.velocity = 200
            cell.color = $0.cgColor
            cell.spin = .pi * 2
            cell.yAcceleration = 20
            cell.contents = UIImage(named: imageName)!.cgImage
            return cell
        }
        
        
        cAEmitterLayer!.emitterCells = cells
        
        view.layer.addSublayer(cAEmitterLayer!)
        
    }
    
    func stopAnimation(){
        self.cAEmitterLayer?.birthRate = 0
    }
    
}
