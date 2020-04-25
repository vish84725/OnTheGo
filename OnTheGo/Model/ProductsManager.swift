//
//  ProductsManager.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation
import Firebase

//MARK: - Prodcut Manager Delagate
protocol ProductManagerDelegate {
    func didCreateProduct(_ productsManager: ProductsManager, product: Product)
    func didCreateProductFailWithError( error: Error)
    func didValidateProductFailWithError(error: String)
    func didLoadProducts(_ productsManager: ProductsManager, products: [Product])
}


//MARK: - Products Manager
struct ProductsManager {
    //MARK: Properties
    var delegate: ProductManagerDelegate?
    private let db = Firestore.firestore()
    private let helper = Helper()
    
    //MARK: Validate Product Category
    func validateProduct(name: String?,quantity: Int?)->Bool{
        
        if name == nil || name == ""{
            return validateMessage(validationMessage: K.ValidationMessage.Product.valRequiredProduct)
        }
        return true
        
    }
    
    //To Do: Find a way to move this to Validator class
    private func validateMessage(validationMessage: String)->Bool{
        let localizedValidationMessage = helper.getLocalizedMessage(message: validationMessage, comment: "")
        delegate?.didValidateProductFailWithError(error: localizedValidationMessage)
        return false
    }
    
    //MARK: Create Product
    func createProduct(with product: Product)->Void{
        self.db.collection(K.FStore.Product.collectionName)
            .addDocument(data: [K.FStore.Product.name:product.name,
                                K.FStore.Product.quantity:product.quantity,
                                K.FStore.Product.category:product.categoryId,
                                K.FStore.Product.createdDate:Date().timeIntervalSince1970])
            {(error) in
                if let e = error{
                    print(e.localizedDescription, Date(), to: &Logger.log)
                    self.delegate?.didCreateProductFailWithError(error: e)
                }
                else{
                    //Success Create Product
                    self.delegate?.didCreateProduct(self, product: product)
                }
        }
    }
    
    func getAllProduct(catId: String)->Void{
        var prodList = [Product]()
        db.collection(K.FStore.Product.collectionName).whereField(K.FStore.Product.category, isEqualTo: catId).getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription, Date(), to: &Logger.log)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let name = data[K.FStore.Product.name] as? String,
                        let quantity = data[K.FStore.Product.quantity] as? Int,
                        let catUid = data[K.FStore.Product.category] as? String{
                        let prod = Product(uid: document.documentID, name: name, categoryId: catUid, quantity: quantity)
                        prodList.append(prod)
                    }
                }
                //Load Products after succession
                self.delegate?.didLoadProducts(self, products: prodList)
            }
        }
    }
}
