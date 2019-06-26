//
//  StarWarsCharacterViewModel.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 11.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// ViewModel for the Character Type
struct StarWarsCharacterViewModel {
    let client = StarWarsAPIClient()
    let name: String
    let characterBirthYear: String
    var characterHome: String
    let characterHeight: String
    let characterEyeColor: String
    let characterHairColor: String
}

extension StarWarsCharacterViewModel {
    
    init(from character: StarWarsCharacter) {
        self.name = character.name
        self.characterBirthYear = character.born
        self.characterHome = character.home
        let height = Double(character.height!) != nil ? "\(character.height!)m"  : "\(character.height!)"
        self.characterHeight = height
        self.characterEyeColor = character.eyeColor
        self.characterHairColor = character.hairColor
    }
    
}
