//
//  PostMapSearchResultsTableViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-08.
//  Copyright © 2018 Fair Fees. All rights reserved.
//
import UIKit
import MapKit


class PostMapSearchResultsTableViewController: UITableViewController {
    
    var previousVC: PostMapViewController!
    
    public var searchResults: [MKLocalSearchCompletion]!
    public var placeToSearch: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchResults = [MKLocalSearchCompletion]()
    }
    
    //auto-complete table View methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placeToSearch = searchResults[indexPath.row].title
        dismiss(animated: true, completion: nil)
        let presentingViewController = self.presentingViewController as! PostMapViewController
        presentingViewController.locationPlotter()
    }
    
}
