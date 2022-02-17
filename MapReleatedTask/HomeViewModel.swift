//
//  HomeViewModel.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation
import GoogleMaps
import GooglePlaces

class HomeViewModel: NSObject {
    let placesClient: GMSPlacesClient!
    var marker: CustomMarker!
    
    var locationManager: CLLocationManager!
    
    var autocompleteController: GMSAutocompleteViewController!
    
    var destinationLocation: CLLocationCoordinate2D?
    
    var routePolyline: GMSPolyline!
    
    var didReceiveDirectionDetailsFromServer: ((HomeMapViewDataModel)->Void)?
    var didReceiveDirectionDetailErrorFromServer: ((String)->Void)?
    
    
    override init() {
        locationManager = CLLocationManager()
        placesClient = GMSPlacesClient.shared()
    }
    
    func makeRequestForDirectionPath(for placeId: String) {
        placesClient.lookUpPlaceID(placeId) { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                
                guard let currentLat = self.locationManager.location?.coordinate.latitude,
                    let currentLong = self.locationManager.location?.coordinate.longitude
                    else {
                        return
                }
                self.destinationLocation = place.coordinate
                let params = ["origin": "\(currentLat), \(currentLong)",
                    "destination": "\(place.coordinate.latitude), \(place.coordinate.longitude)",
                    "sensor": "false",
                    "mode": "driving",
                    "key": "AIzaSyCGX6aGjOeMptlBNc0WF3vhm0SPMl1vNBE"]
                
                NetworkService.shared.makeRequestForRouteDirection(with: params) {[weak self] (result) in
                    switch result {
                    case .success(let result):
                        let mainRoute = result.routes?.first
                        guard let polyLineString = mainRoute?.overviewPolyline?.points else { return }
                        let distance = mainRoute?.legs?.first?.distance?.text ?? "Distance Not found"
                        let duration = mainRoute?.legs?.first?.duration?.text ?? "Duration Not found"
                        
                        let details = HomeMapViewDataModel(destinationAddress: place.formattedAddress ?? "No Address",
                                                           coordinate: place.coordinate,
                                                           polyLineString: polyLineString,
                                                           distance: distance,
                                                           duration: duration)
                        
                        self?.didReceiveDirectionDetailsFromServer?(details)

                    case .failure(let error):
                        self?.didReceiveDirectionDetailErrorFromServer?(error.localizedDescription)
                    }
                }
            } else {
                print("No place details for \(placeId)")
            }
        }
    }

    func getAddress(handler: @escaping (String) -> Void)
    {
        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!,
                                  longitude: (locationManager.location?.coordinate.longitude)!)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
          
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
          
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                address += street + ", "
            }
           
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
         
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                address += zip + ", "
            }
          
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                address += country
            }
           
           handler(address)
        })
    }
    
}

struct HomeMapViewDataModel {
    let destinationAddress: String
    let coordinate: CLLocationCoordinate2D
    
    let polyLineString: String
    let distance: String
    let duration: String
}


