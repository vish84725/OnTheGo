//
//  LoginViewController.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var authenticationManager = AuthenticationManager()
    private var loggedUser:UserDetails? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initService()
    }
    
    func initService(){
        authenticationManager.loginUserManagerdelegate = self
        authenticationManager.userDetailsDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loginSegue{
            let destinationVC = segue.destination as! HomeViewController
            destinationVC.loggedInUser = loggedUser
        }
    }
    
    
    //MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        let isValidUser = authenticationManager.validateUserDetails(email: email, password: password)
        
        if isValidUser{
            self.showWaitOverlay()
            authenticationManager.loginUser(with: email!, for: password!)
        }
    }
    
}

//MARK: - Authentication Manager Delegate
extension LoginViewController: LoginUserManagerDelegate{
    func didLoginUser(_ authenticationManager: AuthenticationManager, userId: String) {
        DispatchQueue.main.async {
            self.removeAllOverlays()
            self.showWaitOverlay() //Should be loading user info
        }
        
        self.authenticationManager.getUser(with: userId)
    }
    
    func didLoginUserFailedWithError(error: Error) {
        self.removeAllOverlays()
        AlertsHandler.showAlertWithErrorMessage(title: NSLocalizedString(K.Alert.ErrorTitle, comment: ""), message:NSLocalizedString(K.ErrorMessage.UserDetails.loginUser, comment: "") )
        print(error.localizedDescription, Date(), to: &Logger.log)
    }
    
    func didLoginUserValidationFailed(error: String) {
        AlertsHandler.showAlertWithErrorMessage(title: NSLocalizedString(K.Alert.ErrorTitle, comment: ""), message: error)
    }
    
    
}

//MARK: - User Details Delegate
extension LoginViewController: UserDetailsDelegate{
    func didUserDetailsLoaded(_ authenticationManager: AuthenticationManager, from user: UserDetails) {
        loggedUser = user
        self.removeAllOverlays()
        if user.userRole == .admin{
            self.performSegue(withIdentifier: K.adminLoginSegue, sender: self)
        }
        else if user.userRole == .customer{
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
        else if user.userRole == .serviceProvider{
            self.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
    }
    
    
}

