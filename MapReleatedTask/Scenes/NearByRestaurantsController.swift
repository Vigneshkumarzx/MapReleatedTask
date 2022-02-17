//
//  NearByRestaurantsController.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation
import UIKit

class NearByRestaurantsController: UIViewController {
    @IBOutlet weak var currentLocationAddress: UILabel!
    @IBOutlet weak var resturentListTableView: UITableView!
    
    var formatedCurrentAddress: String?
    var lon: String!
    var lat: String!
    var nearByResturentsViewModal: NearByResturentsViewModal!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearByResturentsViewModal = NearByResturentsViewModal()
        nearByResturentsViewModal.params = ["location": "\(lat!), \(lon!)",
            "radius": "25000",
            "type": "restaurant",
            "keyword": "cruise",
            "key": "AIzaSyCGX6aGjOeMptlBNc0WF3vhm0SPMl1vNBE"]
        nearByResturentsViewModal.makeRequestForNearByRestaurant()
        resturentListTableView.delegate = self
        resturentListTableView.dataSource = self
       
        currentLocationAddress.text = formatedCurrentAddress
        
        let headerNib = UINib(nibName: "NearByRestTableViewCell", bundle: nil)
        resturentListTableView.register(headerNib, forCellReuseIdentifier: "NearByRestTableViewCell")
        
        let contentNib = UINib(nibName: "NearbyRest1TableViewCell", bundle: nil)
        resturentListTableView.register(contentNib, forCellReuseIdentifier: "NearbyRest1TableViewCell")
        nearByResturentsViewModal.didReceiveNearByRestaurentFromServer = setupDataForMapRestaurentList
        nearByResturentsViewModal.didReceiveNearByRestaurentErrorFromServer = presentAlert(with:)
    }
    private func setupDataForMapRestaurentList() {
        DispatchQueue.main.async {[weak self] in
            self?.resturentListTableView.reloadData()
        }
    }
}

extension NearByRestaurantsController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = resturentListTableView.dequeueReusableCell(withIdentifier: "NearByRestTableViewCell") as! NearByRestTableViewCell
        guard let resturent = nearByResturentsViewModal.resturentList?[section] else { return cell }
        cell.addTapGestureRecognizer(with: #selector(handleTap), target: self, tag: section)
        cell.setup(restaurent: resturent)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let section: Int = sender.view?.tag else { return }
        nearByResturentsViewModal.resturentList?[section].isSelected()
        resturentListTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        nearByResturentsViewModal.resturentList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let resturentList = nearByResturentsViewModal.resturentList else { return 0 }
        return resturentList[section].isOpened ? 1 : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resturentListTableView.dequeueReusableCell(withIdentifier: "NearbyRest1TableViewCell") as!NearbyRest1TableViewCell
        guard let resturent = nearByResturentsViewModal.resturentList?[indexPath.section] else { return cell }
        cell.setup(restaurent: resturent)
        return cell
    }
}
