//
//  LocationSearchTableViewController.swift
//  SearchMapProject
//
//  Created by alios on 5/11/1404 AP.
//

import UIKit
import MapKit
class LocationSearchTableViewController: UITableViewController {
    var items: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var delegate: HandleMapSearch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row].name
        cell.detailTextLabel?.text = generateAddress(from: items[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.dropPin(at: items[indexPath.row].placemark)
        // khat zir barye in hast ke vaghty vared ViewController my shavim in safhe kenar beravad
        dismiss(animated: true)
        // code zir baraye vasl shodan be map google ast
        /// این کد زیر می تواند به جای کد خط های ۳۵ و ۳۳ به کار رود
//        items[indexPath.row].openInMaps()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        items.count
    }


}
extension LocationSearchTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        search(searchController)
    }
    
    
}
private extension LocationSearchTableViewController{
    func search(_ searchController: UISearchController){
        guard let mapView = mapView,let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start{ response, _ in
            guard let response = response else{return}
            self.items = response.mapItems
            self.tableView.reloadData()
            
        }
    }
    func generateAddress(from item: MKMapItem) -> String{
        let subThoroughfare = item.placemark.subThoroughfare
        let thoroughfare = item.placemark.thoroughfare
        let subAdministrativeArea = item.placemark.subAdministrativeArea
        let administrativeArea = item.placemark.administrativeArea
        
        let firstText = thoroughfare == nil ? (subThoroughfare ?? "") :    thoroughfare!
        let secondText = administrativeArea == nil ? (subAdministrativeArea ?? "") : administrativeArea!
        let thirdText = item.placemark.locality ?? ""
        
        return "\(firstText),\(secondText),\(thirdText)"
    }
}
