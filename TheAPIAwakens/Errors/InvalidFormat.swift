//
//  InvalidFormat.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 24.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

enum InvalidFormat: Error {
    /// Error to be thrown when a number is needed but a different type is provided
    case notANumber
}
