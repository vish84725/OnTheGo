//
//  Helper.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation

struct Helper{
    func getLocalizedMessage(message: String, comment: String)->String{
        return NSLocalizedString(message, comment: comment)
    }
}
