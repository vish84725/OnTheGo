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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logout()
    }
    
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
