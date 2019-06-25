//
//  StarWarsEntitiesDataSource.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 10.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation
import UIKit


class StarWarsEntitiesDataSource: NSObject, UIPickerViewDataSource {
    
    private var entities: [StarWarsEntity]
    let picker: UIPickerView
    
    
    init(entities: [StarWarsEntity], picker: UIPickerView) {
        self.entities = entities
        self.picker = picker
        super.init()
    }
    
    // MARK: - Helper Methods
    
    func update(with names: [StarWarsEntity]) {
        entities = names
    }
    
    // MARK: - Picker View Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return entities.count
    }
    
}
