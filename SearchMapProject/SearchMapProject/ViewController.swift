//
//  ViewController.swift
//  SearchMapProject
//
//  Created by alios on 5/11/1404 AP.
//

import UIKit
import MapKit
protocol HandleMapSearch{
    func dropPin(at placmark: MKPlacemark)
}
class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let locationSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "LocationSearchTableViewControllerID") as! LocationSearchTableViewController
        locationSearchTableViewController.mapView = mapView
        locationSearchTableViewController.delegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTableViewController)
        resultSearchController?.searchResultsUpdater = locationSearchTableViewController
        let searchBar = resultSearchController?.searchBar
        searchBar?.placeholder = "Search..."
        navigationItem.titleView = searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
    }


}

extension ViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.first{
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
}
extension ViewController: HandleMapSearch{
    func dropPin(at placmark: MKPlacemark) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placmark.coordinate
        annotation.title = placmark.name
        annotation.subtitle = placmark.locality ?? ""
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
