//
//  ViewController.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

class HomeViewController: UIViewController, GMSMapViewDelegate  {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchMap: UITextField!
    
  var homeViewModel = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        homeViewModel = HomeViewModel()
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.mapView?.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        
        homeViewModel.locationManager.delegate = self
        homeViewModel.locationManager.startUpdatingLocation()
        
        searchMap.delegate = self
        
        homeViewModel.didReceiveDirectionDetailsFromServer = setupDataForMapView
        homeViewModel.didReceiveDirectionDetailErrorFromServer = presentAlert(with:)
        setupGoogleAutoCompleteController()
   }
    private func setupDataForMapView(with details: HomeMapViewDataModel) {
        DispatchQueue.main.async(execute: {[weak self] in
            self?.searchMap.text = details.destinationAddress
         
            self?.setupDestinationMarker(position: details.coordinate,
                                         mapView: (self?.mapView)!,
                                         distance:details.distance,
                                         duration:details.duration)
            self?.drawPloyLinePath(string: details.polyLineString, mapView: (self?.mapView)!)
        })
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        resetTheMapView()
    }
 
    private func setupDestinationMarker(position: CLLocationCoordinate2D,
                                        mapView: GMSMapView,
                                        distance: String,
                                        duration: String) {
        homeViewModel.marker = CustomMarker(distanceText: distance, durationText: duration)
        homeViewModel.marker.position = position
        homeViewModel.marker.map = mapView
    }
    @IBAction func didTapResturentButton(_ sender: Any) {
        homeViewModel.getAddress(handler: {[weak self] address in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "NearByRestaurantsController") as! NearByRestaurantsController
            vc.formatedCurrentAddress = address
            vc.lat = "\((self?.homeViewModel.locationManager.location?.coordinate.latitude)!)"
            vc.lon = "\((self?.homeViewModel.locationManager.location?.coordinate.longitude)!)"
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
    
    private func resetTheMapView() {
        mapView.clear()
    }
    
    func setupGoogleAutoCompleteController() {
        homeViewModel.autocompleteController = GMSAutocompleteViewController()
        homeViewModel.autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        homeViewModel.autocompleteController.autocompleteFilter = filter
    }
}

extension HomeViewController: UITextFieldDelegate, CLLocationManagerDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchMap {
           
            searchMap.text = ""
            resetTheMapView()
            present(homeViewModel.autocompleteController, animated: true, completion: nil)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
       
        if let destinationLocation = homeViewModel.destinationLocation {
            guard let distance = location?.distance(from: CLLocation(latitude: destinationLocation.latitude,
                                                               longitude: destinationLocation.longitude))
                else { return }
            if distance < 100.0 {
                presentAlert(with: "Your destination in \(distance) meters.")
            }
        }
    }
}

extension HomeViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {[weak self] in
            guard let placeId = place.placeID else { return }
            self?.homeViewModel.makeRequestForDirectionPath(for: placeId)
        }
    }

    private func drawPloyLinePath(string: String, mapView: GMSMapView) {
        let path = GMSPath(fromEncodedPath: string)
        homeViewModel.routePolyline = GMSPolyline(path: path)
        homeViewModel.routePolyline.strokeWidth = 5.0
        homeViewModel.routePolyline.strokeColor = UIColor.black
        homeViewModel.routePolyline.map = mapView
        
        let bounds = GMSCoordinateBounds(path: path!)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

