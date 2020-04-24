//
//  AlertHandler.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/24/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import Foundation
import UIKit

class AlertsHandler{

class func showAlertWithOneAction(title: String, message: String, actionTitle: String, actionFunction: ()) -> Void {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default) {
        UIAlertAction in
        actionFunction
        })
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        topController.present(alert, animated: true, completion: nil)
    }
}

    class func showAlertWithErrorMessage(title: String, message: String) -> Void {
    // Only display an error if we are in the foreground
    if UIApplication.shared.applicationState == UIApplication.State.active {

        let alert = UIAlertController(title: NSLocalizedString(title, comment: "Error"), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style:.default, handler: nil))
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            topController.present(alert, animated: true, completion: nil)
        }
    }
}
    
}
