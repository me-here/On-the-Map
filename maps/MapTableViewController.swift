//
//  MapTableViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit

class MapTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapTableView.reloadData()
        print("Data reloaded.")
    }
    
    @IBAction func logout(_ sender: Any) {
        NetworkRequests.deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !model.allStudentsInfo[indexPath.row].link.isEmpty else {
            print("err")
            return
        }
        let link = URL(string: model.allStudentsInfo[indexPath.row].link)
        UIApplication.shared.open(link!, options: [:], completionHandler: nil)
    }
    
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
