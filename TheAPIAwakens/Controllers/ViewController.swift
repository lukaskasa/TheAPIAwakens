//
//  ViewController.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 09.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Properties
    let client = StarWarsAPIClient()
    var allEntities = [StarWarsEntity]()
    
    /// View Life Cyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        allEntities = []
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Sets the status bar style to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Executed when a particular segue is about to be performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let starWarsEntityViewController =  segue.destination as! StarWarsEntityViewController
        
        if segue.identifier == "showCharacters" {
            starWarsEntityViewController.title = "Characters"
            starWarsEntityViewController.type = .characters
            
            client.getAllCharacters() { entities, error in
                if let characters = entities {
                    self.allEntities += characters.results
                    self.checkIfLoading(segue: segue, entities: characters)
                }
                
                starWarsEntityViewController.starWarsEntities = self.allEntities
                starWarsEntityViewController.selectedEntity = self.allEntities.first

                if error != nil {
                     self.showAlertWith(title: "Error", message: error!.localizedDescription)
                }
            }

        } else if segue.identifier == "showVehicles" {
            starWarsEntityViewController.title = "Vehicles"
            starWarsEntityViewController.type = .vehicles
            
            client.getAllVehicles() { entities, error in
                
                if let vehicles = entities {
                    self.allEntities += vehicles.results
                    self.checkIfLoading(segue: segue, entities: vehicles)
                }
                
                starWarsEntityViewController.starWarsEntities = self.allEntities
                starWarsEntityViewController.selectedEntity = self.allEntities.first
                
                if error != nil {
                     self.showAlertWith(title: "Error", message: error!.localizedDescription)
                }
            }
            
            
        } else if segue.identifier == "showStarships" {
            starWarsEntityViewController.title = "Starships"
            starWarsEntityViewController.type = .starships
            
            client.getAllStarships() { entities, error in
                
                if let starships = entities {
                    self.allEntities += starships.results
                    self.checkIfLoading(segue: segue, entities: starships)
                }
                
                starWarsEntityViewController.starWarsEntities = self.allEntities
                starWarsEntityViewController.selectedEntity = self.allEntities.first
                
                if error != nil {
                    self.showAlertWith(title: "Error", message: error!.localizedDescription)
                }
            }
            
        }
    }
    
    /**
     Checks if data operation is still continuing by checking if a next page exist if not the child view controller is configured
     
     - Parameters:
        -segue: The target segue
        -entities: Generic type Entities conforming to StarWarsObjectPage - to be checked
     
     - Returns: Void.
     */
    func checkIfLoading<Entites: StarWarsObjectPage>(segue: UIStoryboardSegue, entities: Entites) {
        let starWarsEntityViewController = segue.destination as! StarWarsEntityViewController
        if !client.isNextPage(in: entities) {
            starWarsEntityViewController.activityIndicator.stopAnimating()
            starWarsEntityViewController.entityPicker.isUserInteractionEnabled = true
            starWarsEntityViewController.loadingView.isHidden = true
            starWarsEntityViewController.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
}

