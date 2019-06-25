//
//  Array.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 23.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

extension Array where Element == Character {
    
    func getLargest() -> String {
        var largest = self.first
        
        for character in self {
            if Double(character.height!) != nil {
                if Double(character.height!)! > Double(largest!.height!)! {
                    largest = character
                }
            }
        }
        
        return largest?.name ?? ""
    }
    
    func getSmallest() -> String {
        var smallest = self.first
        
        for character in self {
            if Double(character.height!) != nil {
                if Double(character.height!)! < Double(smallest!.height!)! {
                    smallest = character
                }
            }
        }
        
        return smallest?.name ?? ""
    }
}

extension Array where Element == Vehicle {
    
    func getLargest() -> String {
        var largest = self.first
        
        for vehicle in self {
            if Double(vehicle.length) != nil {
                if Double(vehicle.length)! > Double(largest!.length)! {
                    largest = vehicle
                }
            }
        }
    
        return largest?.name ?? ""
    }
    
    func getSmallest() -> String {
        var smallest = self.first
        
        for vehicle in self {
            if Double(vehicle.length) != nil {
                if Double(vehicle.length)! < Double(smallest!.length)! {
                    smallest = vehicle
                }
            }
        }
        
        return smallest?.name ?? ""
    }
}

extension Array where Element == Starship {
    
    func getLargest() -> String {
        var largest = self.first
        
        for vehicle in self {
            if Double(vehicle.length) != nil {
                if Double(vehicle.length)! > Double(largest!.length)! {
                    largest = vehicle
                }
            }
        }
        
        return largest?.name ?? ""
    }
    
    func getSmallest() -> String {
        var smallest = self.first
        
        for vehicle in self {
            if Double(vehicle.length) != nil {
                if Double(vehicle.length)! < Double(smallest!.length)! {
                    smallest = vehicle
                }
            }
        }
        
        return smallest?.name ?? ""
    }
}
