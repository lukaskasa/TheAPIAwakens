//
//  StarWarsVehicleViewModel.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 11.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// ViewModel for the Vehicle(Starship) Type
struct StarWarsVehicleViewModel {
    let name: String
    let vehicleManufacturer: String
    let vehicleCost: String
    let vehicleLength: String
    let vehicleClass: String
    let vehicleCrewNumber: String
}

extension StarWarsVehicleViewModel {
    
    init(from vehicle: Vehicle) {
        self.name = vehicle.name
        self.vehicleManufacturer = vehicle.make
        self.vehicleCost = "\(vehicle.cost!)"
        let length = Double(vehicle.length) != nil ? "\(vehicle.length)m"  : "\(vehicle.length)"
        self.vehicleLength = length
        self.vehicleClass = vehicle.vehicleClass
        self.vehicleCrewNumber = "\(vehicle.crew)"
    }
    
}
