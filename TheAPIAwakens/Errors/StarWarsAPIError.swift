//
//  StarWarsAPIError.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 15.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Errors to be thrown using the Star Wars API
enum StarWarsAPIError: Error {
    case invalidURL
    case invalidData
    case jsonConversionFailure
    case jsonParsingFailure(message: String)
    case requestFailed
    case responseUnsuccessful
}
