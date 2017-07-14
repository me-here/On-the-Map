//
//  MapTableViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class MapTableViewController: UIViewController {
    @IBOutlet weak var mapTableView: UITableView!
    @IBAction func logout(_ sender: Any) {
        NetworkRequests.deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if model.tableViewShouldReloadData {
            if model.shouldReloadData { // table was opened first and needs to get stuff
                let values: [String: String] = [    // headers
                    Constants.Parse.parameters.AppID: Constants.Parse.values.appID,
                    Constants.Parse.parameters.APIKey: Constants.Parse.values.APIKey
                ]

                NetworkRequests.requestWith(requestType: Constants.requestType.GET.rawValue, requestURL: Constants.Udacity.studentLocationsURL, addValues: values, httpBody: nil, completionHandler: {(data, error) in
                    guard let data = data, error == nil else {
                        self.displayError(message: "Pin loading error")
                        return
                    }
                    //print(data)
                    
                    guard let results = data["results"] as? [[String: AnyObject]] else {
                        self.displayError(title: "Pin loading error", message: "Error with GETting map pins")
                        return
                    }
                    _ = model(allPoints: results)
                    model.tableViewShouldReloadData = false
                })
            
            }
            DispatchQueue.main.async {
                self.mapTableView.reloadData()
            }
            model.tableViewShouldReloadData = false
        }
    }
}

extension MapTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.allStudentsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapTableViewCell")
        cell?.textLabel?.text = model.allStudentsInfo[indexPath.row].name
        cell?.detailTextLabel?.text = model.allStudentsInfo[indexPath.row].link
        cell?.imageView?.image = UIImage(named: "pin")
        cell?.accessoryType = .disclosureIndicator
        return cell ?? UITableViewCell()
    }
}

extension MapTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !model.allStudentsInfo[indexPath.row].link.isEmpty else { // Don't open empty links
            self.secondaryError(message: "Empty URL")
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let link = URL(string: model.allStudentsInfo[indexPath.row].link)!
        guard UIApplication.shared.canOpenURL(link) else {
            self.secondaryError(message: "Invalid URL format")
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        UIApplication.shared.open(link, options: [:], completionHandler: {
        _ in
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    private func secondaryError(title:String? = "URL error",message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(.init(title: "Ok.", style: .destructive, handler: {_ in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
