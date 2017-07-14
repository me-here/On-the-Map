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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton(loginButton, color: UIColor(red: 0.808, green: 0.290, blue: 0.196, alpha: 1.0))
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
    
    private func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard !(emailField.text?.isEmpty)! && !(passwordField.text?.isEmpty)! else {
            self.displayError(title: "Empty Field/s", message: "Email and/ or password empty")
            return
        }
        
        self.startAnimating()
        
        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        
        let httpBody = "{\"udacity\": {\"username\": \"\(emailField.text ?? "")\", \"password\": \"\(passwordField.text ?? "")\"}}"
        NetworkRequests.requestWith(requestType: Constants.requestType.POST.rawValue, requestURL: Constants.Udacity.sessionURL, addValues: headers, httpBody: httpBody,isUdacityRequest: true, completionHandler: {(data, error) in
            guard let data = data, error == nil else {
                self.displayError(message: "Error with POST.")
                self.stopAnimating()
                return
            }
            
            guard let account = data["account"] as? [String: AnyObject],
                let registered = account["registered"] as? Bool,
                let key = account["key"] as? String else {
                    self.displayError(message: "Account not registered or incorrect username/ password.")
                    self.stopAnimating()
                    return
            }
            
            model.userID = key
            
            guard let session = data["session"] as? [String: AnyObject],
                let id = session["id"] as? String else {
                    self.displayError(title: "GET Failure", message: "Couldn't retreive session id")
                    self.stopAnimating()
                    return
            }
            
            print(id)
            print(registered)
            self.getName()
            
            self.stopAnimating()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        })
    }
    
    private func getName() {
        NetworkRequests.requestWith(requestType: Constants.requestType.GET.rawValue, requestURL: Constants.Udacity.usersURL + model.userID, addValues: [:], httpBody: nil, isUdacityRequest: true, completionHandler: {
            (data, error) in
            guard error == nil, let data = data else {
                self.displayError(message: "Network error")
                return
            }
            guard let user = data["user"] as? [String: AnyObject],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String else {
                    self.displayError(title: "Username failure", message: "Could not get username")
                    return
            }
            
            // Every Udacity user must have these properties
            
            
            // Give them to model
            model.firstName = firstName
            model.lastName = lastName
            print(firstName, lastName)
        })
    }
    
    override func displayError(title:String? = "Download failure",message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(.init(title: "Ok.", style: .default, handler: {_ in
            alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
