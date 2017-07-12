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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapTableView.reloadData()
        print("Data reloaded.")
        //Annotations.MapAnnotations.insert(contentsOf: Annotations.pointsIAdded, at: 0)  // put my stuff up at the top
    }
    
    @IBAction func logout(_ sender: Any) {
        NetworkRequests.deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let annotationURL = Annotations.MapAnnotations[indexPath.row].subtitle/*, annotationURL != ""*/ else {
            print("err")
            return
        }
        let link = URL(string: annotationURL)
        UIApplication.shared.open(link!, options: [:], completionHandler: {
        bool in
            print("yup")
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Annotations.MapAnnotations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapTableViewCell")
        cell?.textLabel?.text = Annotations.MapAnnotations[indexPath.row].title
        cell?.detailTextLabel?.text = Annotations.MapAnnotations[indexPath.row].subtitle
        cell?.imageView?.image = UIImage(named: "pin")
        cell?.accessoryType = .disclosureIndicator
        return cell ?? UITableViewCell()
    }


}
