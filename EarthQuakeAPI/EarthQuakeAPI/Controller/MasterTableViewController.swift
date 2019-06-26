//
//  MasterTableViewController.swift
//  EarthQuakeAPI
//
//  Created by Boss on 6/26/19.
//  Copyright © 2019 Boss. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    var filterQuake = [QuakeInfo]()
    var dislayData = [QuakeInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUserInterface()
        DataServices.sharedInstance.loadInfo { (json) in
            self.filterQuake = json
            self.dislayData = self.filterQuake
            self.tableView.reloadData()
        }
        configSearchController()
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? WebViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        destination.urlString = dislayData[indexPath.row].url
    }
    
    // internet
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .white
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    func configSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter Place You Want Search"
        navigationItem.searchController = searchController
        searchController.isActive = true
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dislayData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        let quakes = dislayData[indexPath.row]
        cell.magQR.text = String(quakes.mag)
        cell.place1.text = quakes.distainsString
        cell.place2.text = quakes.locationName
        cell.time1.text = quakes.dateString
        cell.time2.text = quakes.timeString
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataServices.sharedInstance.selectedQuake = filterQuake[indexPath.row]
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10.0
    }
}
extension MasterTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        dislayData = searchText.isEmpty ? (filterQuake) : (filterQuake.filter({ (data) -> Bool in
            return data.place.lowercased().contains(searchText.lowercased())
        }))
        tableView.reloadData()
        
    }
}
