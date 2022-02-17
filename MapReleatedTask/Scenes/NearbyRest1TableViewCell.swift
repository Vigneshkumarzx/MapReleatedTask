//
//  NearbyRest1TableViewCell.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 17/02/22.
//

import UIKit

class NearbyRest1TableViewCell: UITableViewCell {

    @IBOutlet weak var formatedAddress: UILabel!
    @IBOutlet weak var restaurentType: UILabel!
    
    func setup(restaurent: ResultForSearch) {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        formatedAddress.text = restaurent.vicinity
        restaurentType.text = restaurent.types?.joined(separator: ", ")
    }
    
}

