//
//  Response.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//


import Foundation
import UIKit

struct GoogleMapRouteResponse: Codable {
    let geocodedWaypoints: [GeocodedWaypoint]?
    let routes: [RouteForDestination]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case geocodedWaypoints = "geocoded_waypoints"
        case routes, status
    }
}

struct GeocodedWaypoint: Codable {
    let geocoderStatus, placeID: String?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeID = "place_id"
        case types
    }
}

struct RouteForDestination: Codable {
    let bounds: Bounds?
    let copyrights: String?
    let legs: [Leg]?
    let overviewPolyline: Polyline?
    let summary: String?
    let warnings, waypointOrder: [String]?

    enum CodingKeys: String, CodingKey {
        case bounds, copyrights, legs
        case overviewPolyline = "overview_polyline"
        case summary, warnings
        case waypointOrder = "waypoint_order"
    }
}

struct Bounds: Codable {
    let northeast, southwest: Northeast?
}

// MARK: - Northeast
struct Northeast: Codable {
    let lat, lng: Double?
}

struct Leg: Codable {
    let distance, duration: Distance?
    let endAddress: String?
    let endLocation: Northeast?
    let startAddress: String?
    let startLocation: Northeast?
    let steps: [Step]?
    let trafficSpeedEntry, viaWaypoint: [String]?

    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
        case steps
        case trafficSpeedEntry = "traffic_speed_entry"
        case viaWaypoint = "via_waypoint"
    }
}

struct Distance: Codable {
    let text: String?
    let value: Int?
}

struct Step: Codable {
    let distance, duration: Distance?
    let endLocation: Northeast?
    let htmlInstructions: String?
    let polyline: Polyline?
    let startLocation: Northeast?
    let travelMode: String?

    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case polyline
        case startLocation = "start_location"
        case travelMode = "travel_mode"
    }
}

struct Polyline: Codable {
    let points: String?
}
