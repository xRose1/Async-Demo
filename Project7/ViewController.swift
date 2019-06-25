//
//  ViewController.swift
//  Project7
//
//  Created by Sbedx4 on 06/24/2019.
//  Copyright © 2019 Sbedx4. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(fetchJSON), with:
            nil)
    }
    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            } }
        performSelector(onMainThread: #selector(showError), with:
            nil, waitUntilDone: false)
    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self,
                                                   from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread:
                #selector(UITableView.reloadData), with: nil, waitUntilDone:
                false)
        } else {
            performSelector(onMainThread: #selector(showError), with:
                nil, waitUntilDone: false)
        }
    }
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message:
            "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
}
}

