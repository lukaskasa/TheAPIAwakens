//
//  StarWarsEntityViewController.swift
//  The API Awakens
//
//  Created by Lukas Kasakaitis on 10.06.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// Label names for the different types of star wars entities
struct AttributeLabels {
    static let characterLabels = ["Born", "Home", "Height", "Eyes", "Hair"]
    static let vehicleLabels = ["Make", "Cost", "Length", "Class", "Crew"]
}

/// Enum to represent the attribute labels
enum AttributeValueLabel: Int {
    case name
    case birthOrMake
    case homeOrCost
    case heightOrLength
    case eyesOrClass
    case hairOrCrew
}

class StarWarsEntityViewController: UIViewController, UIPickerViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet var labelConstraints: [NSLayoutConstraint]!
    @IBOutlet var entityAttributeLabels: [UILabel]!
    @IBOutlet var entityValueLabels: [UILabel]!
    @IBOutlet var entityPicker: UIPickerView!
    @IBOutlet weak var currencySegControl: UISegmentedControl!
    @IBOutlet weak var unitSegControl: UISegmentedControl!
    @IBOutlet weak var showVehiclesButton: UIButton!
    @IBOutlet weak var showCharactersButton: UIButton!
    @IBOutlet weak var showStarshipsButton: UIButton!
    @IBOutlet weak var smallestEntityLabel: UILabel!
    @IBOutlet weak var largestEntityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    
    // MARK: - Properties
    
    let client = StarWarsAPIClient()
    var dataSource: StarWarsEntitiesDataSource?
    var selectedEntity: StarWarsEntity?
    var selectedEntities = [StarWarsEntity]()
    var lastSelectedIndex = 0
    var type: EntityType = .characters
    
    /// Set up the entities
    var starWarsEntities: [StarWarsEntity]? {
        didSet {
            guard let loadedEntities = starWarsEntities else { fatalError() }
            selectedEntities = loadedEntities
            dataSource?.update(with: selectedEntities)
            entityPicker.reloadComponent(0)
            toggleButtons()
            setSmallestLabel()
            setLargestLabel()
        }
    }
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isUserInteractionEnabled = false
        dataSource = StarWarsEntitiesDataSource(entities: [], picker: entityPicker)

        if type == .characters {
            currencySegControl.isEnabled = false
            currencySegControl.alpha = 0
        }

        // UI Set Up
        configureAttributeLabels(for: type)
        loadingView.isHidden = false

        entityPicker.delegate = self
        entityPicker.dataSource = dataSource
    }
    
    override func viewWillLayoutSubviews() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
                loadingView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0),
                loadingView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0),
                loadingView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0)
            ])
        } else {
            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 0),
                loadingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                loadingView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: 0),
                loadingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
            ])
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: - Actions
    
    /// Used to switch the currecy by using a segment control ui element
    @IBAction func switchCurrency(_ sender: Any) {
        switch currencySegControl.selectedSegmentIndex {
        case 0:
            setValueOnAlert(title: "Set Exchange Rate", message: "Please set an exchange rate for Credits to USD.", label: entityValueLabels.first(where: {$0.tag == AttributeValueLabel.homeOrCost.rawValue})!)
        case 1:
            guard let vehicle = selectedEntity as? Vehicle else { return }
            entityValueLabels.first(where: { $0.tag == AttributeValueLabel.homeOrCost.rawValue })?.text  = "\(vehicle.cost!)"
        default: break
        }
    }
    
    /// Used to  switch the units by using a segment control ui eelment
    @IBAction func switchUnits(_ sender: Any) {
        switch unitSegControl.selectedSegmentIndex {
        case 0:
            entityValueLabels.first(where: { $0.tag == AttributeValueLabel.heightOrLength.rawValue })?.text  = "\(convertToInches())ft"
        case 1:
            entityValueLabels.first(where: { $0.tag == AttributeValueLabel.heightOrLength.rawValue })?.text  = "\(getOriginal())m"
        default: break
        }
    }
    
    /// Used to load vehicles from the API associated with the character
    @IBAction func showCharacterVehicles(_ sender: UIButton) {
        showVehiclesButton.isHidden = true
        showStarshipsButton.isHidden = true
        showCharactersButton.isHidden = false
        currencySegControl.isEnabled = true
        currencySegControl.alpha = 1
        let character = selectedEntity as! Character
        type = .vehicles
        configureAttributeLabels(for: type)
        
        client.getVehicles(urls: character.vehicles) { vehicles, error in
            
            if let vehicles = vehicles {
                self.lastSelectedIndex = self.selectedEntities.firstIndex {
                    $0.name == self.selectedEntity!.name
                } ?? 0
                self.selectedEntities = vehicles
                self.selectedEntity = vehicles.first
                self.dataSource?.update(with: self.selectedEntities)
                self.entityPicker.reloadComponent(0)
                self.entityPicker.selectRow(0, inComponent: 0, animated: false)
            }
            
            if error != nil {
                self.showAlertWith(title: "Error", message: error!.localizedDescription)
            }
            
        }
        
    }
    
    /// Used to load starships from the API associated with the character
    @IBAction func showCharacterStarships(_ sender: UIButton) {
        showVehiclesButton.isHidden = true
        showStarshipsButton.isHidden = true
        showCharactersButton.isHidden = false
        currencySegControl.isEnabled = true
        currencySegControl.alpha = 1
        let character = selectedEntity as! Character
        type = .starships
        configureAttributeLabels(for: type)
        
        client.getStarships(urls: character.starships) { starships, error in
            
            if let starships = starships {
                self.lastSelectedIndex = self.selectedEntities.firstIndex {
                    $0.name == self.selectedEntity!.name
                    } ?? 0
                self.selectedEntities = starships
                self.selectedEntity = starships.first
                self.dataSource?.update(with: self.selectedEntities)
                self.entityPicker.reloadComponent(0)
                self.entityPicker.selectRow(0, inComponent: 0, animated: false)
            }
            
            if error != nil {
                self.showAlertWith(title: "Error", message: error!.localizedDescription)
            }
            
        }

    }
    
    /// The back button to return to the current selected character
    @IBAction func showCharacters(_ sender: UIButton) {
        showCharactersButton.isHidden = true
        type = .characters
        currencySegControl.isEnabled = false
        currencySegControl.alpha = 0
        selectedEntity = starWarsEntities![lastSelectedIndex]
        selectedEntities = starWarsEntities!
        dataSource?.update(with: selectedEntities)
        entityPicker.reloadComponent(0)
        entityPicker.selectRow(lastSelectedIndex, inComponent: 0, animated: false)
        configureAttributeLabels(for: type)
        toggleButtons()
    }
    
    
    // MARK: - Helper Methods
    
    /**
     Sets up and shows an Alert to set the currency rate
     
     - Parameters:
     - title: The title of the alert
     - message: The message of the alert
     - style: The style, default is alert
     
     - Returns: Void
     */
    func setValueOnAlert(title: String, message: String, label: UILabel) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let setAction = UIAlertAction(title: "Set", style: .default, handler: { [unowned alertController] _ in
            if let input = alertController.textFields?.first?.text, let value = Double(input) {
                label.text = "\(self.convertToUSD(with: Double(value)))$"
            } else {
               self.showAlertWith(title: "Incorrect format", message: "Please enter a number!")
                self.currencySegControl.selectedSegmentIndex = 1
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        present(alertController, animated: false, completion: nil)
    }
    
    /**
     Sets up the descrptive labels for the different characters and vehicles/starships accordingly
     
     - Parameters:
        - type: Type of entity
     
     - Returns: Void
     */
    func configureAttributeLabels(for type: EntityType) {
        if type == .characters {
            entityAttributeLabels.first(where: {$0.tag == 0 })?.text = AttributeLabels.characterLabels[0]
            entityAttributeLabels.first(where: {$0.tag == 1 })?.text = AttributeLabels.characterLabels[1]
            entityAttributeLabels.first(where: {$0.tag == 2 })?.text = AttributeLabels.characterLabels[2]
            entityAttributeLabels.first(where: {$0.tag == 3 })?.text = AttributeLabels.characterLabels[3]
            entityAttributeLabels.first(where: {$0.tag == 4 })?.text = AttributeLabels.characterLabels[4]
        } else if type == .vehicles || type == .starships {
            entityAttributeLabels.first(where: {$0.tag == 0 })?.text = AttributeLabels.vehicleLabels[0]
            entityAttributeLabels.first(where: {$0.tag == 1 })?.text = AttributeLabels.vehicleLabels[1]
            entityAttributeLabels.first(where: {$0.tag == 2 })?.text = AttributeLabels.vehicleLabels[2]
            entityAttributeLabels.first(where: {$0.tag == 3 })?.text = AttributeLabels.vehicleLabels[3]
            entityAttributeLabels.first(where: {$0.tag == 4 })?.text = AttributeLabels.vehicleLabels[4]
        }
    }
    
    /**
     Update the value labels for characters using the correct viewmodel
     
     - Parameters:
     - character: Type of entity
     
     - Returns: Void
     */
    func updateUI(for character: Character) {
        let viewModel = StarWarsCharacterViewModel(from: character)
        for label in entityValueLabels {
            label.adjustsFontForContentSizeCategory = true
            if label.tag == AttributeValueLabel.name.rawValue {
                label.text = viewModel.name
            } else if label.tag == AttributeValueLabel.homeOrCost.rawValue {
                label.text = viewModel.characterHome
            } else if label.tag == AttributeValueLabel.birthOrMake.rawValue {
                label.text = viewModel.characterBirthYear
            } else if label.tag == AttributeValueLabel.heightOrLength.rawValue {
                label.text = viewModel.characterHeight
            } else if label.tag == AttributeValueLabel.eyesOrClass.rawValue {
                label.text = viewModel.characterEyeColor
            } else if label.tag == AttributeValueLabel.hairOrCrew.rawValue {
                label.text = viewModel.characterHairColor
            }
        }
    }
    
    /**
     Update the value labels for vehicles using the correct viewmodel
     
     - Parameters:
     - character: Type of entity
     
     - Returns: Void
     */
    func updateUI(for vehicle: Vehicle) {
        let viewModel = StarWarsVehicleViewModel(from: vehicle)
        for label in entityValueLabels {
            label.adjustsFontForContentSizeCategory = true
            if label.tag == AttributeValueLabel.name.rawValue {
                label.text = viewModel.name
            } else if label.tag == AttributeValueLabel.homeOrCost.rawValue {
                label.text = viewModel.vehicleCost
            } else if label.tag == AttributeValueLabel.birthOrMake.rawValue {
                label.text = viewModel.vehicleManufacturer
            } else if label.tag == AttributeValueLabel.heightOrLength.rawValue {
                label.text = viewModel.vehicleLength
            } else if label.tag == AttributeValueLabel.eyesOrClass.rawValue {
                label.text = viewModel.vehicleClass
            } else if label.tag == AttributeValueLabel.hairOrCrew.rawValue {
                label.text = viewModel.vehicleCrewNumber
            }
        }
    }
    
    /**
     Update the value labels for starships using the correct viewmodel
     
     - Parameters:
     - character: Type of entity
     
     - Returns: Void
     */
    func updateUI(for starship: Starship) {
        let viewModel = StarWarsVehicleViewModel(from: starship)
        for label in entityValueLabels {
            if label.tag == AttributeValueLabel.name.rawValue {
                label.text = viewModel.name
            } else if label.tag == AttributeValueLabel.homeOrCost.rawValue {
                label.text = viewModel.vehicleCost
            } else if label.tag == AttributeValueLabel.birthOrMake.rawValue {
                label.text = viewModel.vehicleManufacturer
            } else if label.tag == AttributeValueLabel.heightOrLength.rawValue {
                label.text = viewModel.vehicleLength
            } else if label.tag == AttributeValueLabel.eyesOrClass.rawValue {
                label.text = viewModel.vehicleClass
            } else if label.tag == AttributeValueLabel.hairOrCrew.rawValue {
                label.text = viewModel.vehicleCrewNumber
            }
        }
    }
    
    /**
     Update labels using the correct data according to the index in array
     
     - Parameters:
        - row: Index in the array used to get the data from
     
     - Returns: Void
     */
    func updateLabels(for row: Int) {
        if type == .characters {
            guard let character = selectedEntities[row] as? Character else { return }
            updateUI(for: character)
        } else if type == .vehicles {
            guard let vehicle = selectedEntities[row] as? Vehicle else { return }
            updateUI(for: vehicle)
        } else if type == .starships {
            guard let starship = selectedEntities[row] as? Starship else { return }
            updateUI(for: starship)
        }
    }
    
    /**
     Update labels using the correct data according to the index in array
     
     - Parameters:
     - row: Index in the array used to get the data from
     
     - Returns: Void
     */
    func toggleButtons() {
        showVehiclesButton.isHidden = true
        showStarshipsButton.isHidden = true
        
        if let character = selectedEntity as? Character {
            if character.vehicles.count > 0 {
                showVehiclesButton.isHidden = false
            } else {
                showVehiclesButton.isHidden = true
            }
            if character.starships.count > 0 {
                showStarshipsButton.isHidden = false
            } else {
                showStarshipsButton.isHidden = true
            }
        }
        
    }
    
    /**
     Toggle the segment controls if the type is valid for conversion else hide the control by putting the alpha to 0
     
     - Parameters:
        - selected: Selected entity to be passed
     
     - Returns: Void
     */
    func toggleSegmentControls(for selected: StarWarsEntity?) {
        guard let selectedVehicle = selected as? Vehicle else { return }
        
        if Double(selectedVehicle.cost!) == nil {
            currencySegControl.isEnabled = false
        } else {
            currencySegControl.isEnabled = true
        }
        
        if Double(selectedVehicle.length) == nil {
            unitSegControl.isEnabled = false
        } else {
            unitSegControl.isEnabled = true
        }
    }
    
    /**
     Gets the original height and length of the entity when switching back orginal selection
     
     - Returns: Void
     */
    func getOriginal() -> String {
        switch self.type {
        case .characters:
            guard let entity = selectedEntity as? Character else { fatalError() }
            return "\(entity.height!)"
        case .vehicles:
            guard let entity = selectedEntity as? Vehicle else { fatalError() }
            return entity.length
        case .starships:
            guard let entity = selectedEntity as? Starship else { fatalError() }
            return entity.length
        }
    }
    
    /**
     Converts height for characters and length for vehicles/starships accordingly
     
     - Returns: Void
     */
    func convertToInches() -> Double {
        var converted = Double()
        
        if type == .characters {
            if let selectedVehicle = selectedEntity as? Character, let convertedValue = selectedVehicle.convertToInches() {
                converted = convertedValue
            } else if let selectedVehicle = selectedEntity as? Character {
                return Double(selectedVehicle.height!)!
            }
        } else if type == .vehicles {
            if let selectedVehicle = selectedEntity as? Vehicle, let convertedValue = selectedVehicle.convertToInches() {
                converted = convertedValue
            } else if let selectedVehicle = selectedEntity as? Vehicle {
                return Double(selectedVehicle.length)!
            }
        } else if type == .starships {
            if let selectedStarship = selectedEntity as? Starship, let convertedValue = selectedStarship.convertToInches() {
                converted = convertedValue
            } else if let selectedStarship = selectedEntity as? Starship {
                return Double(selectedStarship.length)!
            }
        }
        
        return converted
    }
    
    /**
    Converts credits into USD using a user set multiplier
     
     - Parameters:
     - rate: The conversion rate to be used
     
     - Returns: Void
     */
    func convertToUSD(with rate: Double?) -> Double {
        guard let selectedVehicle = selectedEntity as? Vehicle else { fatalError() }
        guard let rate = rate else { fatalError() }
        return rate * Double(selectedVehicle.cost!)!
    }
    
    /**
     Sets the smallest label for the Starwars entities
     
     - Returns: Void
     */
    func setSmallestLabel() {
        if type == .characters {
            guard let entities = starWarsEntities as? [Character] else { return }
            smallestEntityLabel.text = entities.getSmallest()
        } else if type == .vehicles {
            guard let entities = starWarsEntities as? [Vehicle] else { return }
            smallestEntityLabel.text = entities.getSmallest()
        } else {
            guard let entities = starWarsEntities as? [Starship] else { return }
            smallestEntityLabel.text = entities.getSmallest()
        }
    }
    
    /**
     Sets the largest label for the Starwars entities
     
     - Returns: Void
     */
    func setLargestLabel() {
        if type == .characters {
            guard let entities = starWarsEntities as? [Character] else { return }
            largestEntityLabel.text = entities.getLargest()
        } else if type == .vehicles {
            guard let entities = starWarsEntities as? [Vehicle] else { return }
            largestEntityLabel.text = entities.getLargest()
        } else {
            guard let entities = starWarsEntities as? [Starship] else { return }
            largestEntityLabel.text = entities.getLargest()
        }
    }
    
    // MARK: - Picker View Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        updateLabels(for: row)
        return selectedEntities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEntity = selectedEntities[row]
        unitSegControl.selectedSegmentIndex = 1
        currencySegControl.selectedSegmentIndex = 1
        toggleSegmentControls(for: selectedEntity)
        toggleButtons()
        updateLabels(for: row)
    }
    
}
