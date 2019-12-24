//
//  StarWarsEntitiesDataSource.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 10.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation
import UIKit

/// The Datasource for the UIPickerView
class StarWarsEntitiesDataSource: NSObject, UIPickerViewDataSource {
    
    /// Properties
    private var entities: [StarWarsEntity]
    let picker: UIPickerView
    
    
    /**
     Initializes a PickerView Datasource object.
     
     - Parameters:
        - entities: The session configuration
        - picker:: The UIPickerView used to display the data
     
     - Returns: A Datasource object for the UIPickerVIew to display starwars entities
     */
    init(entities: [StarWarsEntity], picker: UIPickerView) {
        self.entities = entities
        self.picker = picker
        super.init()
    }
    
    // MARK: - Helper Methods
    
    /**
     Update the entities array
     
     - Parameters:
        - names: The Array that stores all the star wars entites
     
     - Returns: Void
     */
    func update(with names: [StarWarsEntity]) {
        entities = names
    }
    
    // MARK: - Picker View Datasource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return entities.count
    }
    
}
