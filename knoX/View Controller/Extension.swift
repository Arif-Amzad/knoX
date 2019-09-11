//
//  Extension.swift
//  knoX
//
//  Created by Arif Amzad on 3/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
