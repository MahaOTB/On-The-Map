//
//  LoginViewController.swift
//  On the Map
//
//  Created by Maha on 13/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: Properties
    
    let segue = "ShowTabBarSegue"
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfUsername.delegate = self
        tfPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUI(enabled: true)
        tfUsername.text?.removeAll()
        tfPassword.text?.removeAll()
    }
    
    // MARK: Actions
    
    @IBAction func loginButtinTaped(_ sender: Any) {
        
        guard let username = tfUsername.text, !username.isEmpty, let password = tfPassword.text, !password.isEmpty else {
            present(Alerts.formulateAlert(title: Alerts.EmptyFieldsTitle, message: Alerts.EmptyFieldsBody), animated: true)
            return
        }
        
        setUI(enabled: false)
        
        UdacityApi.createSession(username: tfUsername.text!, password: tfPassword.text!) { (errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                    self.setUI(enabled: true)
                }
                return
            }
            
            self.performSegue(withIdentifier: self.segue, sender: self)
            
        }
    }
    
    // MARK: Functions
    
    func setUI(enabled: Bool) {
        tfUsername.isEnabled = enabled
        tfPassword.isEnabled = enabled
        btnLogin.isEnabled = enabled
    }
    
}

// MARK: UITextFieldDelegate delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if tfUsername.isFirstResponder {
            tfPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
