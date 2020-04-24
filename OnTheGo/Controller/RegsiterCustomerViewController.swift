//
//  RegsiterCustomerViewController.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit

class RegsiterCustomerViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initService()
    }
    
    func initService(){
        authenticationManager.delegate = self
    }
    
    //MARK: Actions
    @IBAction func registerCustomerButtonPresed(_ sender: UIButton) {
        let email = emailTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let password = paswordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        let isUserValid = authenticationManager.validateUserDetails(email: email, firstName: firstName, lastName: lastName, password: password, confirmPassword: confirmPassword)
        
        if isUserValid{
            let user = UserDetails(email: email!, firstName: firstName!, lastName: lastName!)
            authenticationManager.createUser(with: user, password: password!)
            
        }else{
            //ToDo: Add Alert and handle
        }
    }
    
}
//MARK: - Authentication Manager Delegate
extension RegsiterCustomerViewController: AuthenticationManagerDelegate{
    func didCreateUser(_ authenticationManager: AuthenticationManager, userDetails: UserDetails) {
        self.performSegue(withIdentifier: K.registerSegue, sender: self)
    }
    
    func didCreateUserFailWithError(error: Error) {
        //ToDo: Add Alert
        print("Could not create user \(error.localizedDescription)")
    }
}
