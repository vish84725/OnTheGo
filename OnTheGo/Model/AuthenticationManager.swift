//
//  AuthenticationManager.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation
import Firebase

//MARK: - Register User Manager Delagate
protocol RegisterUserManagerDelegate {
    func didCreateUser(_ authenticationManager: AuthenticationManager, userDetails: UserDetails)
    func didCreateUserFailWithError( error: Error)
    func didFailedUserValidation(error: String)
}

//MARK: - Login User Manager Delegate
protocol LoginUserManagerDelegate {
    func didLoginUser(_ authenticationManager: AuthenticationManager)
    func didLoginUserFailedWithError(error: Error)
    func didLoginUserValidationFailed(error: String)
}


//MARK: - Authentication Manager
struct AuthenticationManager{
    //MARK: Properties
    var registerUserManagerdelegate: RegisterUserManagerDelegate?
    var loginUserManagerdelegate: LoginUserManagerDelegate?
    private let db = Firestore.firestore()
    
    
    //MARK: Validate User
    func validateUserDetails(email: String?, firstName: String?, lastName: String?, password: String?, confirmPassword: String?)->Bool{
        
        if firstName == nil || firstName == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredFname)
        }
        else if lastName == nil || lastName == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequredLName)
        }
        else if email == nil || email == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredEmail)
        }
        else if password == nil || password == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredPassword)
        }
        else if confirmPassword == nil || confirmPassword == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredCPassword)
        }
        else if password != confirmPassword{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valMatchPassword)
        }
        
        return true
        
    }
    
    func validateUserDetails(email: String?, password: String?)->Bool{
        if email == nil || email == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredEmail)
        }
        else if password == nil || password == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredPassword)
        }
        return true
        
    }
    
    private func validateMessage(validationMessage: String)->Bool{
        let localizedValidationMessage = getLocalizedMessage(message: validationMessage, comment: "")
        registerUserManagerdelegate?.didFailedUserValidation(error: localizedValidationMessage)
        return false
    }
    
    private func getLocalizedMessage(message: String, comment: String)->String{
        return NSLocalizedString(message, comment: comment)
    }
    
    //MARK: Create User
    func createUser(with user: UserDetails, password pass: String)->Void{
        Auth.auth().createUser(withEmail: user.email, password: pass) { (authData, error) in
            if let e = error{
                self.registerUserManagerdelegate?.didCreateUserFailWithError(error: e)
            }else{
                self.db.collection(K.FStore.User.userCollectionName)
                    .addDocument(data: [K.FStore.User.firstNameField:user.firstName,
                                        K.FStore.User.emailField:user.email,
                                        K.FStore.User.lastNameField:user.lastName,
                                        K.FStore.User.createdDate:Date().timeIntervalSince1970,
                                        K.FStore.User.userUid:authData!.user.uid])
                    {(error) in
                        if let e = error{
                            self.registerUserManagerdelegate?.didCreateUserFailWithError(error: e)
                        }
                        else{
                            //Success Register User
                            self.registerUserManagerdelegate?.didCreateUser(self, userDetails: user)
                        }
                }
                
            }
        }
    }
    
    //MARK: Login User
    func loginUser(with email: String, for password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
             if let e = error {
                self.loginUserManagerdelegate?.didLoginUserFailedWithError(error: e)
             }else {
                //Success loggin
                self.loginUserManagerdelegate?.didLoginUser(self)
             }
         }
    }
    
    
}
