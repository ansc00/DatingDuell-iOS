//
//  BaseDataViewController.swift
//
//
//  Created by tk on 26.05.21.
//

//This class is for user onboarding
//Base data we need to use this application e.g. name, gender, birthday and so on

import UIKit
import CoreLocation
import Firebase

class BaseDataViewController: UIViewController {
//if adding TAG to a button, the background wont be transparent anymore
//    static let LEFT_SLIDE_BUTTON_TAG = 1
//    static let RIGHT_SLIDE_BUTTON_TAG = 2
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
//    var titleData: [String] = ["Name", "My Gender", "Searched Gender", "Add a Photo", "Location Access"]
    var titleData: [String] = ["Name","Gender","Birthday","Searched gender", "Add a photo from you"]
    
    
    
    var gender: String?
    var searchedGender: String?
    var age: Int = 0
  
    var birthdayTF: UITextField?
    var dotCount = 0
    
    var nameTF: UITextField?
    var allButtonTags = [Int]()
    
    
    var userImageIV: UIImageView?
    var imagePickerController: UIImagePickerController?
    var addPhotoButton = UIButton()
    enum ImageSource {
           case photoLibrary
           case camera
       }
    var frame = CGRect.zero //CGRectZero equals to CGRectMake(0,0,0,0). Usually it's used to fast-initialize CGRect object.
    var locationManager: CLLocationManager?
    var lat: Double?
    var lon: Double?
    var activityIndicator: MyActivityInidicator?
    var overlayForActivityIndicatorV: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

       
        pageControl.numberOfPages = titleData.count
        view.backgroundColor = UIColor.orange
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(titleData.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
        setupScreens()
        updateButtons()
        activityIndicator = MyActivityInidicator(addToView: self.view)
        
        
        
        let uiTapGesture = UITapGestureRecognizer()
        self.scrollView.addGestureRecognizer(uiTapGesture)
        uiTapGesture.addTarget(self, action: #selector(dismissKeyboard(_:)))
         
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //user tapped outside // hide keyboard
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer){
        nameTF!.endEditing(true)
        birthdayTF?.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager?.stopUpdatingLocation()
    }
    
    //handle backButton clicked
    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        self.pageControl.currentPage = (pageControl.currentPage - 1)
        self.scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width * CGFloat(pageControl.currentPage), y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
        
        
        updateButtons()
    }
    
    //handle nextButton clicked
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
        self.pageControl.currentPage = (pageControl.currentPage + 1)
        self.scrollView.scrollRectToVisible(CGRect(x: scrollView.frame.width * CGFloat(pageControl.currentPage), y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
        
        //        print(self.pageControl.currentPage)
        updateButtons()
    }
    
  
    //handle keyboard will show up
   @objc func keyboardWillShow(notification: Notification) {
//       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           print("notification: Keyboard will show")
//           if self.view.frame.origin.y == 0{
//               self.view.frame.origin.y -= keyboardSize.height
//           }
//       }

   }

    //handle keyboard will hide
   @objc func keyboardWillHide(notification: Notification) {
//       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//           if self.view.frame.origin.y != 0 {
//               self.view.frame.origin.y += keyboardSize.height
//           }
//       }
   }
    
  
    //update buttons to move forward /backwards
    func updateButtons(){
        //first sceen has no backbutton
        if pageControl.currentPage == 0 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
        
        //last screen has no forward button
        if pageControl.currentPage == (titleData.count - 1) {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
    }
    
    
    //setup the screen with views
    //each case = 1 screen for onbording
    func setupScreens(){
        
        for index in 0..<titleData.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            switch index {
            case 0:
                //Title name
                let nameLabel = createUILabel(title: titleData[index], x: 10 + (CGFloat(index) * scrollView.frame.width) , y: 50 )
                nameLabel.font = .boldSystemFont(ofSize: 20)
                nameLabel.sizeToFit()
                 
                //Input Textfield
                let textField = createUITextField(x: 10 + (CGFloat(index) * scrollView.frame.width) , y: nameLabel.frame.maxY + 15  , width: scrollView.frame.width - 2, height: 35)
                self.nameTF = textField
                self.nameTF!.delegate = self
                
                
                //Description
                let _ = createUILabel(title: "Hey, tell us your name?", x: 10 + (CGFloat(index) * scrollView.frame.width) , y: textField.frame.maxY + 10 )
                 
                break
            case 1:
                
                //Title gender
                let genderLabel = createUILabel(title: titleData[index], x: 10 + (CGFloat(index) * scrollView.frame.width) , y: 50 )
                genderLabel.font = .boldSystemFont(ofSize: 20)
                genderLabel.sizeToFit()
                 
                //Segment Control to choose
                let items = ["Man", "Woman"]
                let sControl = createUISegmentedControl(itemsArray: items,x: 10 + (CGFloat(index) * scrollView.frame.width) , y: genderLabel.frame.maxY + 15  , width: scrollView.frame.width - 30, height: 35)
                sControl.addTarget(self, action: #selector(handleSCChangedValue), for: .valueChanged)
                self.gender = sControl.titleForSegment(at: sControl.selectedSegmentIndex) //default value
                //Description
                let _ = createUILabel(title: "Wich Gender are you?", x: 10 + (CGFloat(index) * scrollView.frame.width) , y: sControl.frame.maxY + 10 )
                 
                break
            case 2:
                //Title Birthday
                let birthdayLabel = createUILabel(title: titleData[index], x: 10 + (CGFloat(index) * scrollView.frame.width) , y: 50 )
                birthdayLabel.font = .boldSystemFont(ofSize: 20)
                birthdayLabel.sizeToFit()
                 
                //Input Textfield age
                let textField = createUITextField(x: 10 + (CGFloat(index) * scrollView.frame.width) , y: birthdayLabel.frame.maxY + 15  , width: scrollView.frame.width - 25, height: 35)
                textField.keyboardType = .numberPad
                textField.placeholder = "DD.MM.YYYY"
                textField.addTarget(self, action: #selector(handleBirthdayValueChanged(_:)), for: .editingChanged)
                self.birthdayTF = textField
                
                
                //Description
                let _ = createUILabel(title: "When is your Birthday?", x: 10 + (CGFloat(index) * scrollView.frame.width) , y: textField.frame.maxY + 10 )
                
                
                
                break
            case 3:
                //Title searched gender
                let genderLabel = createUILabel(title: titleData[index], x:  (CGFloat(index) * scrollView.frame.width) , y: 50 )
                genderLabel.font = .boldSystemFont(ofSize: 20)
                genderLabel.sizeToFit()
                //set new position
                genderLabel.frame = CGRect(  x:  (CGFloat(index) * scrollView.frame.width) + (scrollView.frame.width / 2) - (genderLabel.frame.width / 2) , y: 50, width: genderLabel.frame.width, height: genderLabel.frame.height)
                
                //lets go button
                let buttonWidth: CGFloat = 150
                let xPosition: CGFloat = (CGFloat(index) * scrollView.frame.width) + (scrollView.frame.width / 2) - (buttonWidth / 2)
                let titleText = ["Man","Woman"]
//                let titleText = ["Man","Woman","Both"]
                var yDistance = 0
                var buttonsArray = [UIButton]()
                for i in 0..<titleText.count {
                    yDistance = i + 1
                    let myButton = createUIButton(title: titleText[i], x: xPosition, y: genderLabel.frame.maxY + 50 * CGFloat(yDistance))
                    myButton.tag = yDistance //1, 2, 3... as tag
                    self.allButtonTags.append(myButton.tag)
//                    print("tag: " + String(myButton.tag))
                    myButton.addTarget(self, action: #selector(handleSearchedGenderButtonClicked(_:)), for: .touchUpInside)
                    buttonsArray.append(myButton)
                    
                }
                self.handleSearchedGenderButtonClicked(buttonsArray[1]) //set default to woman
                
                //Description
                let descrLabel = createUILabel(title: "What are you searching?", x:  (CGFloat(index) * scrollView.frame.width) , y: buttonsArray.last!.frame.maxY + 10 )
                //set new position
                descrLabel.frame = CGRect(  x:  (CGFloat(index) * scrollView.frame.width) + (scrollView.frame.width / 2) - (descrLabel.frame.width / 2) , y: buttonsArray.last!.frame.maxY + 10 , width: descrLabel.frame.width, height: descrLabel.frame.height)
               
               
                break
            
            case 4:
                //Title Add an Image
                let imageLabel = createUILabel(title: titleData[index], x:  (CGFloat(index) * scrollView.frame.width) , y: 50 )
                imageLabel.font = .boldSystemFont(ofSize: 20)
                imageLabel.sizeToFit()
                //set new position
                imageLabel.frame = CGRect(  x:  (CGFloat(index) * scrollView.frame.width) + (scrollView.frame.width / 2) - (imageLabel.frame.width / 2) , y: 50, width: imageLabel.frame.width, height: imageLabel.frame.height)
                
                //Userphoto
                self.userImageIV = UIImageView()
                userImageIV!.frame = CGRect(x: 10 +  (CGFloat(index) * scrollView.frame.width), y: imageLabel.frame.maxY + 5 , width: scrollView.frame.width - 20 , height: scrollView.frame.height / 1.7)
                userImageIV?.layer.cornerRadius = 10
                userImageIV?.layer.borderWidth = 1
                userImageIV?.layer.borderColor = UIColor.black.cgColor
                self.scrollView.addSubview(userImageIV!)
                //ad tap imageView gesture
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleAddPhotoButtonClicked(_:)))
                self.userImageIV?.isUserInteractionEnabled = true
                self.userImageIV?.addGestureRecognizer(tapGesture)
                
                
                //add photo label
                self.addPhotoButton = UIButton()
//                addPhotoButton.setTitle("add", for: .normal) //if title used > tint color is auto WHITE mb because dark, light modus?
                addPhotoButton.tintColor = UIColor.black
                addPhotoButton.backgroundColor = UIColor.white //
                
                
                
                addPhotoButton.sizeToFit()
                let myButtonWidth: CGFloat = addPhotoButton.frame.width + 50
                let myButtonHeight: CGFloat = myButtonWidth
                addPhotoButton.frame = CGRect(x:  (CGFloat(index) * scrollView.frame.width) + (scrollView.frame.width / 2) - (myButtonWidth / 2) , y: (userImageIV!.frame.maxY - ( userImageIV!.frame.height / 2 )) - (myButtonHeight / 2) , width: myButtonWidth, height: myButtonHeight )
                addPhotoButton.setImage(UIImage(named: "camera"), for: .normal)
                addPhotoButton.clipsToBounds = true
                addPhotoButton.layer.cornerRadius = 10
               
                addPhotoButton.addTarget(self, action: #selector(handleAddPhotoButtonClicked(_:)), for: .touchUpInside)
                self.scrollView.addSubview(addPhotoButton)
                
                
                //lets go button
                let startButton = UIButton()
                startButton.setTitle("Lets go", for: .normal)
                startButton.layer.cornerRadius = 10
                startButton.tintColor = UIColor.black
                startButton.backgroundColor = UIColor.blue
                startButton.sizeToFit()
                let startButtonWidth: CGFloat = 150
                let xPos: CGFloat = (CGFloat(index) * scrollView.frame.width) + (scrollView.frame.width / 2) - (startButtonWidth / 2)
                startButton.frame = CGRect(x: xPos, y: userImageIV!.frame.maxY + 30 , width: startButtonWidth, height: 40)
                self.scrollView.addSubview(startButton)
                startButton.addTarget(self, action: #selector(handleGoButtonClicked(_:)), for: .touchUpInside)
                
                
                break
            
            default:
                break
            }
            
           
            }
            
    
    }
    
    //handle addphoto button clicked
    //user can choose a image from device or camera
    @objc func handleAddPhotoButtonClicked(_ sender: UIButton){
       
        let alert = UIAlertController(title: "Add a photo", message: "Select a source", preferredStyle: .alert)
        let camAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.selectImageFrom(ImageSource.camera)
        }
        let libAction = UIAlertAction(title: "Galary", style: .default) { action in
             
            self.selectImageFrom(ImageSource.photoLibrary)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
           //nothing
        }
        alert.addAction(camAction)
        alert.addAction(libAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    //gesture
    @objc func handleAddPhotoTappedGesture(_ sender: UITapGestureRecognizer){
        handleAddPhotoButtonClicked(self.addPhotoButton)
        
    }
    
    //select image source and present UIIMagePickerController
    func selectImageFrom(_ source: ImageSource){
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController!.delegate = self
        self.imagePickerController?.allowsEditing = true //allow editing //zoom, crop etc.
        switch source {
        case .camera:
            self.imagePickerController!.sourceType = .camera
            break
        case .photoLibrary:
            self.imagePickerController!.sourceType = .photoLibrary
            break
        }
        
        self.present(imagePickerController!, animated: true, completion: nil)
    }
    
    
    
    @objc func handleSearchedGenderButtonClicked(_ sender: UIButton){
        
        for i in 0..<self.allButtonTags.count {
            if let button = self.view.viewWithTag(allButtonTags[i]) as? UIButton {
            
            // Deselect/Disable these buttons
            button.backgroundColor = #colorLiteral(red: 0.80803, green: 0.803803, blue: 0.805803, alpha: 1)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.isSelected = false
            }
        }

            // Select/Enable clicked button //current button clicked
            sender.backgroundColor =  #colorLiteral(red: 0.1843137255, green: 0.6823529412, blue: 0.9764705882, alpha: 1)
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.isSelected = true
            self.searchedGender = sender.currentTitle
    }
    
    //create a button
    func createUIButton(title: String, x: CGFloat, y: CGFloat) -> UIButton {
        let myButton = UIButton()
        myButton.setTitle(title, for: .normal)
        myButton.layer.cornerRadius = 10
//        myButton.tintColor = UIColor.black
//        myButton.backgroundColor = UIColor.white
        myButton.layer.borderWidth = 1
        myButton.layer.borderColor = UIColor.black.cgColor
        // Deselect/Disable these buttons
        myButton.backgroundColor = #colorLiteral(red: 0.80803, green: 0.803803, blue: 0.805803, alpha: 1)
        myButton.setTitleColor(UIColor.darkGray, for: .normal)
        myButton.isSelected = false
//        myButton.sizeToFit()
        myButton.frame = CGRect(x: x , y: y, width: 150, height: 40)
        self.scrollView.addSubview(myButton)
        
        return myButton
    }
    
    
    //user clicked go
    @objc func handleGoButtonClicked(_ sender: UIButton) {
        if areInputfieldsValid() {
            //get Current Location
           getCurrentLocation()
            
        } else {
            //show alert if not all fields filled
            showMessageDialog(title: "Alert", msg: "Please fill all fields")
        }
        
    }
    
 
    
    //get the current location from user
    //ask first time for persmission
    func getCurrentLocation() {
         
        //show Activity Indicator
        self.activityIndicator?.showActivityIndicator()
        
        self.locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
//        locationManager?.requestWhenInUseAuthorization()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestLocation() //onetime request for location
        
    
      
    }
    
    //show a message dialog
    func showMessageDialog(title: String,  msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            //nothing
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //check if inputfiels are valid
    func areInputfieldsValid() -> Bool {
        var isValid = false
        if self.nameTF!.text!.count > 1 && age > 0 && age < 110 && searchedGender!.count > 0 && self.userImageIV?.image != nil  {
                isValid = true
            
        } else {
            isValid = false
        }
         
           return isValid
    }
    
    //handle birthday
    @objc func handleBirthdayValueChanged(_ sender: UITextField){
        if !sender.text!.isEmpty {

            var myText: String = ""
            let textChar = Array(sender.text!)
            
            sender.backgroundColor = .none
            
            if textChar.count == 2 {
                
                myText = String(textChar[0]) + String(textChar[1])
                self.birthdayTF?.text = myText
                self.dotCount = 0
            
            } else if textChar.count == 3 && dotCount == 0 {
             
                myText = String(textChar[0]) + String(textChar[1]) + "." +   String(textChar[2])
                self.birthdayTF?.text = myText
                self.dotCount = 1
            } else if textChar.count == 3  && dotCount == 1 { //erease
             
                myText = String(textChar[0]) + String(textChar[1])
                self.birthdayTF?.text = myText
                self.dotCount = 0
                
            } else if textChar.count == 6 && dotCount == 1 {
                myText = String(textChar[0]) + String(textChar[1]) +  String(textChar[2]) + String(textChar[3]) + String(textChar[4]) + "." + String(textChar[5])
                self.birthdayTF?.text = myText
                self.dotCount = 2
            } else if textChar.count == 6 && dotCount == 2 { //erease
                myText = String(textChar[0]) + String(textChar[1]) +  String(textChar[2]) + String(textChar[3]) + String(textChar[4])
                self.birthdayTF?.text = myText
                self.dotCount = 1
            } else if textChar.count == 10 && dotCount == 2 {
                
                if isValidDate(dateString: sender.text!) {
                    sender.backgroundColor = UIColor.green
                    self.birthdayTF!.endEditing(true) //hint keyboard
//                    print("Age: " + String(calculateAge(dateString: sender.text!)))
                    self.age = Calculate.calculateAge(dateString: sender.text!)
                } else {
                    sender.backgroundColor = UIColor.red
                }
            } else if textChar.count > 10 {
                sender.backgroundColor = UIColor.red
            }
            
        }
//        print("Dotcount: " + String(dotCount))

    }
    
    //check if date is valid
    func isValidDate(dateString: String) -> Bool {
       
        if let _ = Calculate.dateFormatter.date(from: dateString) {
           //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
           return true
       } else {
           // Invalid date
           return false
       }
   }
    
   
    
    
    
    @objc func handleSCChangedValue(sender: UISegmentedControl){
//        if sender.selectedSegmentIndex == 0 { //Man
//            print("man")
//            self.gender = sender.titleForSegment(at: sender.selectedSegmentIndex)
//        } else if sender.selectedSegmentIndex == 1 { //Woman
//            print("woman")
            self.gender = sender.titleForSegment(at: sender.selectedSegmentIndex)
//        }
    }
    
    //create UILabel
    func createUILabel(title: String, x: CGFloat, y: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        label.frame = CGRect(x: x , y: y  , width: label.frame.width, height: label.frame.height)
        self.scrollView.addSubview(label)
        
        return label
    }
    
    // create UITextField
    func createUITextField(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UITextField {
        let textField = UITextField()
        textField.frame = CGRect(x: x, y: y, width: width, height: height)
        self.scrollView.addSubview(textField)
        
        let lineView = UIView()
        lineView.backgroundColor = .black
        lineView.frame = CGRect(x: x , y: textField.frame.maxY - 3  , width: self.scrollView.frame.width - 30 , height: 1)
        self.scrollView.addSubview(lineView)
        
        return textField
    }
    
    // create UISegmentedControl
    func createUISegmentedControl(itemsArray: [String], x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UISegmentedControl {
        let sControl = UISegmentedControl(items: itemsArray)
        sControl.selectedSegmentIndex = 0
        sControl.frame = CGRect(x: x, y: y, width: width, height: height)
        self.scrollView.addSubview(sControl)
        
         
        
        return sControl
    }

  

    
 

    
}



//MARK: - UITextFieldDelegate

extension BaseDataViewController: UITextFieldDelegate {

//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("begin")
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("shoudlEnd")
//        return true
//    }
    //enter pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == K.nameInputTextfieldTag {
            textField.endEditing(true) //hint keyboard after enter pressed
//            self.buttonClicked(self.nextButton) //nextButton clicked

        } else if textField.tag == K.birthdayInputTextfieldTag {

        }

        return true
    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("didEndEditing")
//    }
}

//MARK: - ImagePicker
extension BaseDataViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.imagePickerController!.dismiss(animated: true, completion: nil)
        var selectedImage: UIImage?
        //[UIImagePickerController.InfoKey : Any]  = Datatype = Dictionary
        if let editImage = info[.editedImage] as? UIImage{ //get edited image
            selectedImage = editImage
        }

        if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage == nil {
            return
        }
        
        self.userImageIV!.image = selectedImage
        self.userImageIV?.clipsToBounds = true
        self.addPhotoButton.isHidden = true
        
        }
 
}



// MARK: - Location Manager
extension BaseDataViewController: CLLocationManagerDelegate {

    
    func saveDataToFirebase(){
        let  coord = MyCoordinate(lat: self.lat!, lon: self.lon!)
        let  userBaseData = UserBaseData(id: Auth.auth().currentUser!.uid,
                                             email: Auth.auth().currentUser!.email!,
                                             name: self.nameTF!.text!,
                                             gender: self.gender!,
                                             birthday: self.birthdayTF!.text!,
                                             searchedGender: self.searchedGender!,
                                             image: userImageIV!.image!,
                                             likes: 0, //first value
                                             dislikes: 0, //first value
                                             userCounter: 0, //firstValue //dont USE!
                                             myCoordinate: coord)
        Database.saveBaseDataToDB(userBaseData) { isSuccesful in
            if isSuccesful {
                self.performSegue(withIdentifier: K.baseDataToDuellVCIdentifier, sender: nil)
            } else {
                self.showMessageDialog(title: "Error", msg: "Something went wrong! try again later...")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1] as CLLocation
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
        
        //hide/stop Activity Indicator
        self.activityIndicator?.hideActivityIndicator()
        
        
        saveDataToFirebase()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
        print(error.localizedDescription)
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    askUserAgainForLocationPermission()
            case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    print("but other error...")
                @unknown default:
                break
            }
            } else {
                print("Location services are not enabled")
        }
    }
    
    func askUserAgainForLocationPermission() {
        let alertController = UIAlertController(title: "Permissions required", message: "We need your location to calculate the distance between you and others. Please go to Settings and turn on the permissions", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        //hide/stop Activity Indicator
                        self.activityIndicator?.hideActivityIndicator()
                    })
                 }
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                                             //hide/stop Activity Indicator
            self.activityIndicator?.hideActivityIndicator()
        })

            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)

           
            self.present(alertController, animated: true, completion: nil)
        
        
            
    }
}



 //MARK: - ScrollView
extension BaseDataViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //dont allow vertical scroll
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(pageNumber)
//            print(pageControl.currentPage)
            updateButtons()
        
        
    }
}

