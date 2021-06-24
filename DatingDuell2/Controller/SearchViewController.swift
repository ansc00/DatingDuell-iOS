//
//  SearchViewController.swift
//  DatingDuell2
//
//  Created by tk on 10.06.21.
//

//The user can search for other users and chat with them

import UIKit
//import CoreData

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        // Do any additional setup after loading the view.
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:))))

    }
    

    @objc func dismissKeyboard(_ sender: UIGestureRecognizer){
        searchbar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let myText = searchbar?.text {
            if myText.count > 0 {
    //            let request = NSFetchRequest(entityName: "MyEntity")
                //do search
                //dispatchQueue.main.async > reload data
                print("searched for: " + searchbar.text!)
            }
        }
        
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.text = ""
        
        DispatchQueue.main.async {
            self.searchbar.resignFirstResponder() //remove cursor from searchbar
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text?.count == 0 {
            //load default items
        }
    }
}
