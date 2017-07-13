//
//  LoginViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/9/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton(loginButton)
        setupTextField(emailField)
        setupTextField(passwordField)
        emailField.delegate = self
        passwordField.delegate = self
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
        emailField.text = ""
        passwordField.text = ""
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: Constants.Udacity.udacitySignUpURLString)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard !(emailField.text?.isEmpty)! && !(passwordField.text?.isEmpty)! else {
            self.displayError(title: "Empty Field/s", message: "Email and/ or password empty")
            return
        }
        
        var headers: [String: String] = [:]
        headers["Accept"] = "application/json" // Accept is unique. application/json isn't.
        headers["Content-Type"] = "application/json"
        let httpBody = "{\"udacity\": {\"username\": \"\(emailField.text ?? "")\", \"password\": \"\(passwordField.text ?? "")\"}}"
        NetworkRequests.requestWith(requestType: Constants.requestType.POST.rawValue, requestURL: Constants.Udacity.sessionURL, addValues: headers, httpBody: httpBody,isUdacityRequest: true, completionHandler: {(data, error) in
                guard let data = data, error == nil else {
                    self.displayError(message: "No network.")
                    return
                }
            
                guard let account = data["account"] as? [String: AnyObject],
                    let registered = account["registered"] as? Bool,
                    let key = account["key"] as? String else {
                    self.displayError(message: "Account not registered or incorrect username/ password.")
                    return
                }
                
                Constants.Udacity.userID = key

                let session = data["session"] as! [String: AnyObject]
                let id = session["id"] as! String
                print(id)
                print(registered)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
    }
    
    func displayError(title:String? = "Login Failure",message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(.init(title: "Ok", style: .cancel, handler: {_ in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
