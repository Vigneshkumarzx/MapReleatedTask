//
//  NearbyViewModel.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation

class NearByResturentsViewModal: NSObject {
    var resturentList: [ResultForSearch]?
    
    var params: [String: Any]!
    
    var didReceiveNearByRestaurentFromServer: (()->Void)?
    var didReceiveNearByRestaurentErrorFromServer: ((String)->Void)?

    func makeRequestForNearByRestaurant() {
        NetworkService.shared.makeRequestForNearByResturents(with: params) {[weak self] (result) in
            switch result {
            case .success(let result):
                self?.resturentList = result.results
                self?.didReceiveNearByRestaurentFromServer?()
            case .failure(let error):
                self?.didReceiveNearByRestaurentErrorFromServer?(error.localizedDescription)
            }
        }
    }
    
}
