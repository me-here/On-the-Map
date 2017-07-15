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
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty && !password.isEmpty else {
            self.displayError(title: "Empty Field/s", message: "Email and/ or password empty")
            return
        }
        
        self.startAnimating()
        NetworkRequests.login(email: email, password: password, err: {
            errorString in
            self.stopAnimating()
            self.displayError(message: errorString)
        }, completion: {
            NetworkRequests.getName(err: {
                errorString in
                self.displayError(message: errorString)
            })
            
            self.stopAnimating()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
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
