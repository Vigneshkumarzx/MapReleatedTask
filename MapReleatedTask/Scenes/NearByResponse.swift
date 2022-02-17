//
//  NearByResponse.swift
//  MapReleatedTask
//
//  Created by vignesh kumar c on 16/02/22.
//

import Foundation

struct NearByResturentResponse: Codable {
    let htmlAttributions: [String]?
    var results: [ResultForSearch]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case results, status
    }
}

struct ResultForSearch: Codable {
    var isOpened: Bool = false
    let businessStatus: String?
    let geometry: Geometry?
    let icon: String?
    let name: String?
    let photos: [Photo]?
    let placeID: String?
    let plusCode: PlusCode?
    let rating: Double?
    let reference, scope: String?
    let types: [String]?
    let userRatingsTotal: Int?
    let vicinity: String?
    let openingHours: OpeningHours?
    let priceLevel: Int?
    
    mutating func isSelected() { isOpened = !isOpened}

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon, name, photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
        case openingHours = "opening_hours"
        case priceLevel = "price_level"
    }
}

struct Geometry: Codable {
    let location: Location?
    let viewport: Viewport?
}

struct Location: Codable {
    let lat, lng: Double?
}

struct Viewport: Codable {
    let northeast, southwest: Location?
}

struct OpeningHours: Codable {
    let openNow: Bool?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Photo: Codable {
    let height: Int?
    let htmlAttributions: [String]?
    let photoReference: String?
    let width: Int?

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

struct PlusCode: Codable {
    let compoundCode, globalCode: String?

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}
