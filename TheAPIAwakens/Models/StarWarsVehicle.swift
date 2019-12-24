//
//  StarWarsVehicle.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 11.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

protocol StarWarsVehicle: StarWarsEntity {
    var make: String { get }
    var cost: String? { get }
    var length: String { get }
    var vehicleClass: String { get }
    var crew: String { get }
}

protocol StarWarsShip {
    var starshipClass: String { get }
}
