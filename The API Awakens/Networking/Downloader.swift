//
//  Downloader.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 17.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

class Downloader {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias DataTaskCompletionHandler = (Data?, StarWarsAPIError?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler completion: @escaping DataTaskCompletionHandler) -> URLSessionTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
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
