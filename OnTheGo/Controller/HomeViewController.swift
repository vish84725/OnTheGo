//
//  HomeViewController.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/26/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var homeDisplayLabel: UILabel!
    var loggedInUser: UserDetails? {
         didSet {
             setData()
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    private func setData(){
        if let user = loggedInUser{
            DispatchQueue.main.async {
                self.homeDisplayLabel.text = "Hi \(user.firstName) \(user.lastName)"
            }

            print(user.firstName)
        }
    }
    
    //MARK: Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logout()
    }
    
    //TO DO: This method is duplicating in admin 
    private func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError{
            print("Error Signing out : %@", signOutError)
        }
    }
}
