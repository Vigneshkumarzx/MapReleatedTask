//
//  NearByRestTableViewCell.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import UIKit

class NearByRestTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurentIcon: UIImageView!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var restaurentStatus: UILabel!
    
    func setup(restaurent: ResultForSearch) {
        restaurentIcon.setImage(from: restaurent.icon ?? Route.defaultImageAddress.description)
        restaurentIcon.contentMode = .scaleToFill
        restaurentName.text = restaurent.name ?? "No name"
        restaurentStatus.text = restaurent.businessStatus ?? "No name"
    }
}

