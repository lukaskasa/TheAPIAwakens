//
//  Downloader.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 17.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

/// Used to create a data task
class Downloader {
    
    /// Properties
    let session: URLSession
    
    /**
     Initializes a new downloader with a specific session configuration.
     
     - Parameters:
        - configuration: The session configuration
     
     - Returns: A downloader object handler data tasks
     */
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    /**
     Initializes a new downloader with a default session configuration.
     
     - Returns: A downloader object handler data tasks
     */
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Typealias for the completion handler
    typealias DataTaskCompletionHandler = (Data?, StarWarsAPIError?) -> Void
    
    /**
     Creates a new data session task
     
     - Parameters:
        -request: The request to be used for the data task
        -completion: The completion handler to be called when the task is completed
     
     - Returns: Void.
     */
    func dataTask(with request: URLRequest, completionHandler completion: @escaping DataTaskCompletionHandler) -> URLSessionTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            // Check if response was successful
            if httpResponse.statusCode == 200 {
                
                if let data = data {
                    completion(data, nil)
                }
                
            } else {
                completion(nil, .responseUnsuccessful)
            }
                
        }
        
        return task
    }
    
}
