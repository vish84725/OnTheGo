//
//  Product.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation

struct Product{
    let uid: String?
    let name: String
    let categoryId: String
    let category: ProductCategory? = nil
    let quantity: Int
}
