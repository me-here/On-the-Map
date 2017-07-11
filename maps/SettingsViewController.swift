//
//  SettingsViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func udacityLogout(_ sender: Any) {
        deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func deleteSession() {
        var headers: [String: String] = [:]
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Constants.Udacity.sessionCookie.cookieName {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {    // nil check
            headers[Constants.Udacity.sessionCookie.headerName] = xsrfCookie.value
        }
        NetworkRequests.requestWith(requestType: Constants.requestType.DELETE.rawValue, requestURL: Constants.Udacity.sessionURL, addValues: headers, httpBody: nil, completionHandler: {(data,error) in
            guard let data = data, error == nil else {
                print("Network failure.")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: String.Encoding.utf8) ?? "Failure")
        })
    }
}
