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
    func didLoginUser(_ authenticationManager: AuthenticationManager, userId: String)
    func didLoginUserFailedWithError(error: Error)
    func didLoginUserValidationFailed(error: String)
}

//MARK: - User Details Delegate
protocol UserDetailsDelegate {
    func didUserDetailsLoaded(_ authenticationManager: AuthenticationManager,from user: UserDetails)
    //func didLoginUserFailedWithError(error: Error)
    //func didLoginUserValidationFailed(error: String)
}


//MARK: - Authentication Manager
struct AuthenticationManager{
    //MARK: Properties
    var registerUserManagerdelegate: RegisterUserManagerDelegate?
    var loginUserManagerdelegate: LoginUserManagerDelegate?
    var userDetailsDelegate: UserDetailsDelegate?
    private let db = Firestore.firestore()
    private let helper = Helper()
    
    
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
    
    func validateProviderDetails(email: String?, firstName: String?, lastName: String?, password: String?, confirmPassword: String?, phoneNumber: String?, nic: String?, categoryId: String?)->Bool{
        
        if firstName == nil || firstName == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredFname)
        }
        else if lastName == nil || lastName == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequredLName)
        }
        else if email == nil || email == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredEmail)
        }
        else if phoneNumber == nil || phoneNumber == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredPhoneNumber)
        }
        else if Int(phoneNumber!) == nil{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valTypePhoneNumber)
        }
        else if nic == nil || nic == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredNic)
        }
        else if categoryId == nil || categoryId == ""{
            return validateMessage(validationMessage: K.ValidationMessage.UserDetails.valRequiredCategory)
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
        let localizedValidationMessage = helper.getLocalizedMessage(message: validationMessage, comment: "")
        registerUserManagerdelegate?.didFailedUserValidation(error: localizedValidationMessage)
        return false
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
                                        K.FStore.User.userRole:user.userRole.rawValue,
                                        K.FStore.User.createdDate:Date().timeIntervalSince1970,
                                        K.FStore.User.phoneNumber:user.phoneNumber != nil ? user.phoneNumber!: 0,
                                        K.FStore.User.nic:user.nic != nil ? user.nic! : 0,
                                        K.FStore.User.productCategory:user.categoryId != nil ? user.categoryId! : 0,
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
                self.loginUserManagerdelegate?.didLoginUser(self,userId: (authData?.user.uid)!)
            }
        }
    }
    
    func getUser(with userId: String)-> Void{
        var user: UserDetails? = nil
        db.collection(K.FStore.User.userCollectionName).whereField(K.FStore.User.userUid, isEqualTo: userId).getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription, Date(), to: &Logger.log)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let fName = data[K.FStore.User.firstNameField] as? String
                    let lName = data[K.FStore.User.lastNameField] as? String
                    let phoneNumber = data[K.FStore.User.phoneNumber] as? Int
                    let nic = data[K.FStore.User.nic] as? String
                    let email = data[K.FStore.User.emailField] as? String
                    let userRole = data[K.FStore.User.userRole] as? Int
                    let catId = data[K.FStore.User.productCategory] as? String
                    
                    let domUser = UserDetails(email: email!, firstName: fName!, lastName: lName!, uid: userId, userRole: UserRole(rawValue: userRole!)!, phoneNumber: Int(phoneNumber!), nic: nic, categoryId: catId)
                    
                    user = domUser
                    
                }
                if user != nil{
                    self.userDetailsDelegate?.didUserDetailsLoaded(self, from: user!)
                }else{
                    //To Do: error must be handled
                    print("couldnt retrieve logged in user details",Date(),to: &Logger.log)
                }
            }
        }
    }
    
    
}
