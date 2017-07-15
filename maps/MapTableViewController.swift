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
        if StudentInformation.tableViewShouldReloadData {
            if StudentInformation.shouldReloadData { // table was opened first and needs to get stuff
                NetworkRequests.reloadData(err: {
                    errString in
                    self.displayError(message: errString)
                }, completion: {
                    StudentInformation.tableViewShouldReloadData = false
                    DispatchQueue.main.async {
                        self.mapTableView.reloadData()
                    }
                })
            }
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
}
