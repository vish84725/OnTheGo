//
//  UserDetails.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation
import Firebase

struct UserDetails{
    var email: String
    var firstName: String
    var lastName: String
    var uid: String?
    var userRole: UserRole
    var phoneNumber:Int? = nil
    var nic: String? = nil
    var categoryId: String? = nil
    
}

enum UserRole: Int {
    case admin = 1
    case serviceProvider
    case customer
}



