//
//  Character.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 09.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Units used to convert between english and meters
struct Units {
    static let oneMeterInInches: Double = 39.37
    static let oneFootInInches: Double = 12
}

struct Characters: Decodable, StarWarsObjectPage {
    let next: URL?
    var results: [Character]
}

struct Character: StarWarsCharacter, StarWarsEntity {
    let name: String
    let born: String
    var home: String // New Request
    let height: String?
    let eyeColor: String
    let hairColor: String
    
    let vehicles: [URL] // New Request
    let starships: [URL] // New Request
    
    
    func convertToInches() -> Double? {
        // 1 Meter = 39,37 inches
        // 1 Foot = 12 inches
        // 1 Meter = 3 feet 3⅜
        // e.g. 1.8 * 39,37 / 12
        return ((Double(self.height!)! * Units.oneMeterInInches) / Units.oneFootInInches).rounded(toPlaces: 2)
    }
    
}

extension Character: Decodable {
    
    private enum ChracterKeys: String, CodingKey {
        case name = "name"
        case born = "birth_year"
        case home = "homeworld"
        case height = "height"
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case vehicles = "vehicles"
        case starships = "starships"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChracterKeys.self)
    
        self.name = try container.decode(String.self, forKey: .name)
        self.home = try container.decode(String.self, forKey: .home)
        self.born = try container.decode(String.self, forKey: .born)
        self.eyeColor = try container.decode(String.self, forKey: .eyeColor)
        self.hairColor = try container.decode(String.self, forKey: .hairColor)
        
        self.vehicles = try container.decode([URL].self, forKey: .vehicles)
        self.starships = try container.decode([URL].self, forKey: .starships)

        
        if let height = try container.decodeIfPresent(String.self, forKey: .height), let heightValue = Double(height) {
            self.height = "\(heightValue / 100)"
        } else {
            self.height = "unknown"
        }
        
    }
    
}
