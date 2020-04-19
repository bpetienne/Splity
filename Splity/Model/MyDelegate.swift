//
//  MyDelegate.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 07/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

protocol ModelDelegate1 {
    func errorUpdating(error: Error)
    func modelUpdated()
    func modelUpdated(type: String, records: [CKRecord], database: CKDatabase)
}

protocol DateSelectorViewControllerDelegate: class {
    func selectedDate(sender: DateSelectorViewController, date:Date?)
}

protocol NewTravellerViewModelDeletage{
    func addNewTraveller(sender: UIViewController, travellerViewModel:TravellerViewModel? )
}

protocol ModelDelegate: Codable {
    func tripDidFinish( trip: Trip)
    func tryRemoveTraveller(travellerId: String)
    var allTravellers: [String:Traveler] { get }
    func getTraveller(id: String) -> Traveler?
    func travellerIsUsed(travellerId: String) -> Bool
    func save(traveller: Traveler)
}


protocol ModelManagerProtocol  {
    func add(cost: Cost)
    func update(cost: Cost)
    func delete(cost: Cost)
    
    func add(trip: Trip)
    func update(trip: Trip)
    func delete(trip: Trip)
    
    func add(traveler: Traveler)
    func update(traveler: Traveler)
    func delete(traveler: Traveler)
}

protocol DataManagerProtocol {
    func save(trip: Trip)
    func save(cost: Cost)
    func save(traveler: Traveler)
    
    func initialize()
    //Save locally
    //Save on iCloud
    
    //Get update from iCloud and update Model
    
    //Manage pending iCloud items
    
}
