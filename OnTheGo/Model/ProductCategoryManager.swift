//
//  ProductCategoryManager.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation
import Firebase

//MARK: - Prodcut Category Manager Delagate
protocol ProductCategoryManagerDelegate {
    func didCreateProductCategory(_ productsCategoryManager: ProductCategoryManager, category: ProductCategory)
    func didCreateProductCategoryFailWithError( error: Error)
    func didValidateProductCategoryFailWithError(errorMessage: String)
    func didLoadProductCategories(_ productsCategoryManager: ProductCategoryManager, categories: [ProductCategory])
    
}


//MARK: - Products Category Manager
struct ProductCategoryManager {
    //MARK: Properties
    var delegate: ProductCategoryManagerDelegate?
    private let db = Firestore.firestore()
    private let helper = Helper()
    
    //MARK: Validate Product Category
    func validateProductCategory(catogoryName: String?)->Bool{
        
        if catogoryName == nil || catogoryName == ""{
            return validateMessage(validationMessage: K.ValidationMessage.ProductCategory.valRequiredProductCategory)
        }
        return true
        
    }
    
    //To Do: Find a way to move this to Validator class
    private func validateMessage(validationMessage: String)->Bool{
        let localizedValidationMessage = helper.getLocalizedMessage(message: validationMessage, comment: "")
        delegate?.didValidateProductCategoryFailWithError(errorMessage: localizedValidationMessage)
        return false
    }
    
    //MARK: Create Product Category
    func createProductCategory(with category: ProductCategory)->Void{
        self.db.collection(K.FStore.ProductCategory.collectionName)
            .addDocument(data: [K.FStore.ProductCategory.name:category.name,
                                K.FStore.ProductCategory.createdDate:Date().timeIntervalSince1970])
            {(error) in
                if let e = error{
                    print(e.localizedDescription, Date(), to: &Logger.log)
                    self.delegate?.didCreateProductCategoryFailWithError(error: e)
                }
                else{
                    //Success Create Product Category
                    self.delegate?.didCreateProductCategory(self, category: category)
                }
        }
    }
    
    func getAllProductCategory()->Void{
        var catList = [ProductCategory]()
        db.collection(K.FStore.ProductCategory.collectionName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription, Date(), to: &Logger.log)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let catName = data[K.FStore.ProductCategory.name] as? String{
                        let prodCat = ProductCategory(uid: document.documentID, name: catName)
                        catList.append(prodCat)
                    }
                }
                //Load Categories after succession
                self.delegate?.didLoadProductCategories(self, categories: catList)
            }
        }
    }
}
