//
//  Extension_UITextViewDelegate.swift
//  On the Map
//
//  Created by Maha on 17/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import UIKit

extension ShareLocationViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        
        let isDefaultString = CommonFuncInUITextViewDelegate.removeDefaultString(textView: textView, defaultString: "Enter Your Location Here")
        return isDefaultString
    }
    
    // Allow return button to dismiss the keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let isAllowToEdite = CommonFuncInUITextViewDelegate.returnButtonPressed(textView: textView, text: text)
        return isAllowToEdite
    }
    
}


extension ShareLinkViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        
        let isDefaultString = CommonFuncInUITextViewDelegate.removeDefaultString(textView: textView, defaultString: "Enter a Link to Share Here")
        return isDefaultString
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let isAllowToEdite = CommonFuncInUITextViewDelegate.returnButtonPressed(textView: textView, text: text)
        return isAllowToEdite
    }
}

// MARK: Common functions used in this delegate

struct CommonFuncInUITextViewDelegate {
    
    static func removeDefaultString (textView: UITextView, defaultString: String) -> Bool {
        if textView.text ==  defaultString{
            textView.text.removeAll()
        }
        return true
    }
    
    static func returnButtonPressed(textView: UITextView, text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
