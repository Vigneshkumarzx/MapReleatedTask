//
//  File.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation
import GoogleMaps
import GooglePlaces

class CustomMarker: GMSMarker {

    var distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
        return lbl
    }()
    
    var durationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
        return lbl
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "map")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    init(distanceText: String, durationText: String) {
        super.init()

        containerView.addSubview(distanceLabel)
        containerView.addSubview(durationLabel)
        containerView.addSubview(iconImageView)
        
        distanceLabel.text = distanceText
        durationLabel.text = durationText
        
        
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: durationLabel.bottomAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        iconView = containerView
    }
}
