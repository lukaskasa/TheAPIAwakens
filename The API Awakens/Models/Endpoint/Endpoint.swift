//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 10.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum StarWarsEntityEndpoint {
    case people(page: Int)
    case vehicles(page: Int)
    case starships(page: Int)
}

extension StarWarsEntityEndpoint: Endpoint {
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        switch self {
        case .people:
            return "/api/people/"
        case .vehicles:
            return "/api/vehicles/"
        case .starships:
            return "/api/starships/"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .people(let page), .vehicles(let page), .starships(let page):
            var result = [URLQueryItem]()
            let pageNumber = URLQueryItem(name: "page", value: page.description)
            result.append(pageNumber)
            return result
        }
    }
    
    
}

