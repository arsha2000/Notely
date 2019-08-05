//
//  UIAlertController_Extensions.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit


extension UIAlertController {
    
    static func alertWithTextField(title: String, message: String?, textFieldPlaceholder: String?, handler: @escaping (String) -> ()) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(cancel)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            handler(controller.textFields!.first!.text!)
        }
        okAction.isEnabled = false
        controller.addAction(okAction)
        
        controller.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { (_) in
                
                let okActionDisabled = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
                okAction.isEnabled = !okActionDisabled
                
            }
            
        }
        
        return controller
    }
}
