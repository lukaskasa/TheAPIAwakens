//
//  StarWarsCharacter.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 11.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

protocol StarWarsCharacter: StarWarsEntity {
    var born: String { get }
    var home: String { get }
    var height: String? { get } // URL
    var eyeColor: String { get }
    var hairColor: String { get }
    var vehicles: [URL] { get }  // New Request
    var starships: [URL] { get } // New Request
}


