//
//  AuthenticationManager.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation
import Firebase

protocol AuthenticationManagerDelegate {
    func didCreateUser(_ authenticationManager: AuthenticationManager, userDetails: UserDetails)
    func didCreateUserFailWithError( error: Error)
}

struct AuthenticationManager{
    var delegate: AuthenticationManagerDelegate?
    let db = Firestore.firestore()
    
    func validateUserDetails(email: String?, firstName: String?, lastName: String?, password: String?, confirmPassword: String?)->Bool{
        
        //ToDo: Handle Validation Accordingly
        
        if email == nil{
            return false
        }
        else if firstName == nil{
            return false
        }
        else if lastName == nil{
            return false
        }
        else if password == nil{
            return false
        }
        else if confirmPassword == nil{
            return false
        }
        else if password != confirmPassword{
            return false
        }
        return true
        
    }
    
    func createUser(with user: UserDetails, password pass: String)->Void{
        Auth.auth().createUser(withEmail: user.email, password: pass) { (authData, error) in
            if let e = error{
                print(user.email)
                print(e.localizedDescription)
                self.delegate?.didCreateUserFailWithError(error: e)
            }else{
                self.db.collection(K.FStore.userCollectionName)
                    .addDocument(data: [K.FStore.firstNameField:user.firstName,
                                        K.FStore.lastNameField:user.lastName,
                                        K.FStore.userUid:authData!.user.uid])
                    {(error) in
                        if let e = error{
                            self.delegate?.didCreateUserFailWithError(error: e)
                        }
                        else{
                            self.delegate?.didCreateUser(self, userDetails: user)
                        }
                }
                
            }
        }
    }
    
    
}
