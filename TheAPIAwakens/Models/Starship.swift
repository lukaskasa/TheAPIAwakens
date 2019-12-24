//
//  Starship.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 09.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

struct Starships: Decodable, StarWarsObjectPage {
    let next: URL?
    let results: [Starship]
}

class Starship: Vehicle, StarWarsShip {
    var starshipClass: String
    
    private enum StarshipKeys: String, CodingKey {
        case starshipClass = "starship_class"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StarshipKeys.self)
        self.starshipClass = try container.decode(String.self, forKey: .starshipClass)
        try super.init(from: decoder)
        self.vehicleClass = self.starshipClass
    }

}
