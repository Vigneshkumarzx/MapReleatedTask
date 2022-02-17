//
//  Route.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation

enum Route {
    static let baseURL = "https://maps.googleapis.com/maps/api"
    
    case defaultImageAddress
    case destinationDirections
    case nearByResturents

    var description: String {
        switch self {
        case .destinationDirections: return "/directions/json"
        case .nearByResturents: return "/place/nearbysearch/json"
        case .defaultImageAddress: return "https://i.pinimg.com/originals/4e/24/f5/4e24f523182e09376bfe8424d556610a.png"
        }
    }
}
