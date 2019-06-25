//
//  Vehicle.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 09.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

struct Vehicles: Decodable, StarWarsObjectPage {
    let next: URL?
    let results: [Vehicle]
}

class Vehicle: StarWarsVehicle, Decodable {
    var name: String
    var make: String
    var cost: String?
    var length: String
    var vehicleClass: String
    var crew: String
    
    private enum VehicleKeys: String, CodingKey {
        case name = "name"
        case make = "manufacturer"
        case cost = "cost_in_credits"
        case length = "length"
        case vehicleClass = "vehicle_class"
        case crew = "crew"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VehicleKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.make = try container.decode(String.self, forKey: .make)
        self.length = try container.decode(String.self, forKey: .length)
        self.crew = try container.decode(String.self, forKey: .crew)
        
        if container.contains(.vehicleClass) {
            self.vehicleClass = try container.decode(String.self, forKey: .vehicleClass)
        } else {
            self.vehicleClass = "Unclassed"
        }
        
        if let cost = try container.decodeIfPresent(String.self, forKey: .cost) {
            self.cost = cost
        } else {
            self.cost = "unknown"
        }
    }
    
    init(name: String, make: String, cost: String, length: String, vehicleClass: String, crew: String) {
        self.name = name
        self.make = make
        self.cost = cost
        self.length = length
        self.vehicleClass = vehicleClass
        self.crew = crew
    }
    
    func convertToInches() -> Double? {
        // 1 Meter = 39,37 inches
        // 1 Foot = 12 inches
        // 1 Meter = 3 feet 3⅜
        // e.g. 1.8 * 39,37 / 12
        return ((Double(self.length)! * Units.oneMeterInInches) / Units.oneFootInInches).rounded(toPlaces: 2)
    }
    
}
