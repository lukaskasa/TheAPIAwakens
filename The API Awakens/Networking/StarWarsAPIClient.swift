//
//  StarWarsAPIClient.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 15.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

class StarWarsAPIClient {
    
    /// Properties
    let jsonDecoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getAllCharacters(pageNumber: Int = 1, completionHandler completion: @escaping (Characters?, Error?) -> Void) {
        
        let endpoint = StarWarsEntityEndpoint.people(page: pageNumber)

        performRequest(with: endpoint.request) { results, error in
            
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            do {
                let characters = try self.jsonDecoder.decode(Characters.self, from: results)
                
                self.getCharacterHome(from: characters) { people, error in
                    if let swCharacters = people {
                        completion(swCharacters, nil)
                    }
                }
                
                if self.isNextPage(in: characters) {

                    self.getAllCharacters(pageNumber: pageNumber + 1) { characters, error in
                        completion(characters, nil)
                    }

                }
                
            } catch let error {
                completion(nil, error)
            }
            
        }
        
    }
    
    func getAllVehicles(pageNumber: Int = 1, completionHandler completion: @escaping (Vehicles?, Error?) -> Void) {
        
        let endpoint = StarWarsEntityEndpoint.vehicles(page: pageNumber)
        
        performRequest(with: endpoint.request) { results, error in
            
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            
            do {
                let vehicles = try self.jsonDecoder.decode(Vehicles.self, from: results)
                completion(vehicles, nil)
                
                if self.isNextPage(in: vehicles) {
                    
                    self.getAllVehicles(pageNumber: pageNumber + 1) { vehicles, error in
                        completion(vehicles, nil)
                    }
                    
                }
                
            } catch let error{
                
                completion(nil, error)
                
            }
            
            
        }
        
    }
    
    func getAllStarships(pageNumber: Int = 1, completionHandler completion: @escaping (Starships?, Error?) -> Void) {
        
        let endpoint = StarWarsEntityEndpoint.starships(page: pageNumber)
        
        performRequest(with: endpoint.request) { results, error in
            
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            do {
                let starships = try self.jsonDecoder.decode(Starships.self, from: results)
                completion(starships, nil)
                
                if self.isNextPage(in: starships) {
                    
                    self.getAllStarships(pageNumber: pageNumber + 1) { starships, error in
                        completion(starships, nil)
                    }
                    
                }
                
            } catch let error {
                completion(nil, error)
            }
            
        }
        
    }
    
    func getVehicles(urls: [URL], completionHandler completion: @escaping ([Vehicle]?, Error?) -> Void) {
        
        var entities = [Vehicle]()
        
        for url in urls {
            let request = URLRequest(url: url)
            performRequest(with: request) { entity, error in
                
                guard let entity = entity else {
                    completion(nil, error)
                    return
                }
                
                
                do {
                    let entity = try self.jsonDecoder.decode(Vehicle.self, from: entity)
                    entities.append(entity)
                    
                    if urls.count == entities.count {
                        completion(entities, nil)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    
    func getStarships(urls: [URL], completionHandler completion: @escaping ([Starship]?, Error?) -> Void) {
        
        var entities = [Starship]()
        
        for url in urls {
            let request = URLRequest(url: url)
            
            performRequest(with: request) { entity, error in
                
                guard let entity = entity else {
                    completion(nil, error)
                    return
                }
                
                do {
                    let entity = try self.jsonDecoder.decode(Starship.self, from: entity)
                    entities.append(entity)
                    
                    if urls.count == entities.count {
                        completion(entities, nil)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
    }
    
   func isNextPage<Entities: StarWarsObjectPage>(in entities: Entities) -> Bool {
        var isNext = false
        
        if entities.next != nil {
            isNext = true
        }
        
        return isNext
    }
    
    /**
     Gets all the Star wars characters and the name of the homeworld by performing an additional request.
     
     - Parameters:
        - characters: The object used to get the URL with the name of homeworld
        - completion:
     
     - Returns: Void.
     */
    private func getCharacterHome(from characters: Characters, completionHandler completion: @escaping (Characters?, StarWarsAPIError?) -> Void) {
        
        var charactersWithHome = characters
        var homes = [String]()
        
        for (index, character) in characters.results.enumerated() {
            
            let url = URL(string: character.home)!
            let request = URLRequest(url: url)
            
            performRequest(with: request) { planet, error in
                
                guard let planet = planet else {
                    completion(nil, error)
                    return
                }
                
                do {
                    let homeworld = try self.jsonDecoder.decode(Planet.self, from: planet)
                    homes.append(homeworld.name)
                    charactersWithHome.results[index].home = homeworld.name
                    if homes.count == charactersWithHome.results.count {
                        completion(charactersWithHome, nil)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }

        }
        
    }
    
    /**
     Performs a datatask request using the Downloader Object
     
     - Parameters:
        - request: The request used to perform.
        - completion: @escaping completionhandler which returns an optional Data Object or an optional StarWarsAPIError
     
     - Returns: Void.
     */
    private func performRequest(with request: URLRequest, completion: @escaping (Data?, StarWarsAPIError?) -> Void) {
        let downloader = Downloader()
        
        let task = downloader.dataTask(with: request) { data, error in
            
            DispatchQueue.main.async {
                
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                
                completion(data, nil)
            }
            
        }
        
        task.resume()
    }
    
}
