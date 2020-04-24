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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initService()
    }
    
    func initService(){
        authenticationManager.loginUserManagerdelegate = self
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
    func didLoginUser(_ authenticationManager: AuthenticationManager) {
        self.removeAllOverlays()
        self.performSegue(withIdentifier: K.loginSegue, sender: self)
        
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

