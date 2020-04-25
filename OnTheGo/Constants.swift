//
//  Constants.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation

struct K {
    //    static let appName = "⚡️FlashChat"
    //    static let cellIdentifier = "ReusableCell"
    //    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterSegue"
    static let loginSegue = "LoginSegue"
    static let adminLoginSegue = "AdminLoginSegue"
    //    static let loginSegue = "LoginToChat"
    
    //    struct BrandColors {
    //        static let purple = "BrandPurple"
    //        static let lightPurple = "BrandLightPurple"
    //        static let blue = "BrandBlue"
    //        static let lighBlue = "BrandLightBlue"
    //    }
    
    struct FStore {
        struct User {
            //MARK: Users Collection
            static let userUid = "uid"
            static let userCollectionName = "users"
            static let firstNameField = "firstName"
            static let lastNameField = "lastName"
            static let emailField = "email"
            static let createdDate = "createdDate"
        }
        
        struct ProductCategory {
            //MARK: Product Category Collction
            static let uid = "uid"
            static let collectionName = "productCategory"
            static let name = "name"
            static let createdDate = "createdDate"
        }
        
        struct Product{
            //MARK: Product Collction
            static let uid = "uid"
            static let collectionName = "product"
            static let name = "name"
            static let quantity = "quantity"
            static let category = "categoryId"
            static let createdDate = "createdDate"
        }
        
    }
    
    struct ErrorMessage {
        struct UserDetails {
            static let createUser = "ErrorUserCreation"
            static let loginUser = "ErrorUserLogin"
        }
        
        struct ProductCategory {
             static let create = "ErrorProductCategoryCreation"
         }
        
        struct Product {
             static let create = "ErrorProductCreation"
         }
    }
    
    struct ValidationMessage {
        struct UserDetails {
            static let valRequiredEmail = "ValRequiredEmail"
            static let valRequiredFname = "ValRequiredFirstName"
            static let valRequredLName = "ValRequiredLastName"
            static let valRequiredPassword = "ValRequiredPassword"
            static let valRequiredCPassword = "ValRequiredConfirmPassword"
            static let valMatchPassword = "ValidBothPassword"
        }
        
        struct ProductCategory {
            static let valRequiredProductCategory = "ValRequiredCategoryName"
        }
        
        struct Product {
            static let valRequiredProduct = "ValRequiredProductName"
            static let valRequiredPCategory = "ValRequiredPCategory"
        }
    }
    
    struct Alert {
        static let ErrorTitle = "ErrorAlert"
    }
    
    struct TableViewCells {
        static let ProductCategoryCell = "ProductCategoryCellID"
        static let ProductCell = "ProductCellID"
        
    }
}
