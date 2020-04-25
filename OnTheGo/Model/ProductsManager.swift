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
    func didFailedProductValidation(error: String)
}


//MARK: - Products Manager
struct ProductsManager {
    //MARK: Properties
    var delegate: ProductManagerDelegate?
    private let db = Firestore.firestore()
}
