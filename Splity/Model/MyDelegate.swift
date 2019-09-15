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
    var allTravellers: [String:Traveller] { get }
    func getTraveller(id: String) -> Traveller?
    func travellerIsUsed(travellerId: String) -> Bool
    func save(traveller: Traveller)
}


protocol ModelManagerProtocol  {
    func add(cost: Cost)
    func update(cost: Cost)
    func delete(cost: Cost)
    
    func add(trip: Trip)
    func update(trip: Trip)
    func delete(trip: Trip)
    
    func add(traveler: Traveller)
    func update(traveler: Traveller)
    func delete(traveler: Traveller)
}

protocol DataManagerProtocol {
    func save(trip: Trip)
    func save(cost: Cost)
    func save(traveler: Traveller)
    
    func initialize()
    //Save locally
    //Save on iCloud
    
    //Get update from iCloud and update Model
    
    //Manage pending iCloud items
    
}
