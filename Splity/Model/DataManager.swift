//
//  DataManager.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 21/03/2019.
//  Copyright © 2019 Benoit ETIENNE. All rights reserved.
//

import Foundation

class DataManager: DataManagerProtocol {
    
    var model: Model = Model()
    
    func initialize(){
        
        if let model = loadModelLocally(){
            self.model = model
        }
        
        for tripId in self.model.tripsUUID {
            if let trip = Trip.loadTripFromJson(tripId: tripId){
                trip.initialize(model: self.model)
                self.model.trips.append(trip)
                trip.recomputeCosts()
            }
            sortedModel()
        }
    }
    
    func sortedModel(){
        self.model.trips = self.model.trips.sorted {$0.beginDate > $1.beginDate}
    }
    
    func loadModelLocally() -> Model?  {
        if let jsonData = read(fromURL: Model.ArchiveJsonURL) {
            return jsonTo(jsonData: jsonData)
        }
        return nil
    }
    
     func loadTripLocally(tripId: String) -> Trip?  {
        if let jsonData = read(fromURL: Trip.getJsonArchiveURL(tripId)) {
            return jsonTo(jsonData: jsonData)
        }
        return nil
    }
    
     func read(fromURL url: URL) -> Data? {
        return  NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? Data
    }
    
    func jsonTo<T: Decodable>(jsonData: Data) -> T?{
        do {
            let decoded = try JSONDecoder().decode(T.self, from: jsonData)
            return decoded
        } catch {
        }
        return nil
    }
    
    func save(trip: Trip){
        
    }
    
    func save(cost: Cost){
        
    }
    
    func save(traveler: Traveller){
        
    }    
}


