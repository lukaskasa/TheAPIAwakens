//
//  StarWarsEntity.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 11.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

enum EntityType {
    case characters
    case vehicles
    case starships
}

protocol StarWarsObjectPage {
    var next: URL? { get }
}

protocol StarWarsEntity {
    var name: String { get }
    func convertToInches() -> Double?
}
