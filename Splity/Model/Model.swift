//
//  Model.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 23/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit


class Model: Codable , ModelDelegate{
    
    //MARK: Properties

    var trips = [Trip]()
    var tripsUUID = [String]()
    var deleteTripsUUID = [String]()
    var travellers = [String:Traveller]()
    var travellersByNickname  = [String:Traveller]()
    var modelId: String = UUID().uuidString
    var appId: String = UUID().uuidString
    var selectedTrip: Trip?
    
    var travellerIds = [String]()

   // var saveCompletion: (()->Void)? = nil
    
    var allTravellers: [String:Traveller] {
        return travellers
    }
    
    struct CloudKey {
        static let tripIds = "tripIds"
        static let deleteTripIds = "deleteTripIds"
        static let travellers = "travellers"
        static let modelId = "modelId"
        static let appId = "appId"
        static let selectedTrip = "selectedTrip"
    }
    
    //MARK: Types
        private enum CodingKeys: String, CodingKey {
            case tripsUUID
            case deleteTripsUUID
            case travellers
            case travellersByNickname
            case modelId
            case appId
            case selectedTrip
            
            case travellerIds

        }
    
    static var categories : [String:Category] =
        [ "Food":.Food,
          "Transport": .Transport,
          "Logement": .Logement,
          "Activity": .Activity,
          "Shopping":.Shopping]
    
    static var concernedPeoples : [String:ConcernedPeople] =
        ["SingleButton":.Single,
         "GroupButton":.Group]
    
    static var payments : [String:Payment] =
        ["CardButton":.Card,
         "CashButton":.Cash]

    init(){
        initialize()
    }
    
    func initialize(){

        let fm = FileManager.default
        let path1 = Configuration.DocumentsDirectory.path
      
        do {
            let items3 = try fm.contentsOfDirectory(atPath:path1)
            
            for item in items3 {
                print("Found \(item)")
                var test = item
                test = test.replacingOccurrences(of: "trip_", with: "")
                test = test.replacingOccurrences(of: ".ctrk", with: "")

                
                if item.contains("trip") {
                    var tes = 3
                }
                
                let tripId = test
                if let trip = Trip.loadTripFromJson(tripId: tripId){
                    trip.initialize(model: self)
                    //trips.append(trip)
                    //trip.recomputeCosts()
                }
                
                if let trip = Trip.loadTripFromJson(tripId: tripId){
                    trip.initialize(model: self)
                    //trips.append(trip)
                    //trip.recomputeCosts()
                }
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
        
        if let model = loadModelJson(){
            self.modelId = model.modelId
            self.appId = model.appId
            self.tripsUUID = model.tripsUUID
            self.deleteTripsUUID = model.deleteTripsUUID
            self.travellers = model.travellers
            self.travellersByNickname = model.travellersByNickname
            self.selectedTrip = model.selectedTrip
        }

        for tripId in tripsUUID {
            if let trip = Trip.loadTripFromJson(tripId: tripId){
                trip.initialize(model: self)
                trips.append(trip)
                trip.recomputeCosts()
            }
            sortedModel()
        }
        
        
//        let modelCloudRequest = ModelCloudRequest()
//        modelCloudRequest.createCustomZone() { (String) in
//        }
//       
//        modelCloudRequest.save(trip: trips.first!) { (String) in
//            
//        }
//        
//        modelCloudRequest.fetchTrips()

    }
    
    func sortedModel(){
        trips = trips.sorted {$0.beginDate > $1.beginDate}
    }
    
    func setTravellerForNewTrip(trip: Trip){
        if (trip.mainCountry == "New York Import"){
            for cost in trip.costs {
                cost.tripId = trip.tripId
                if (cost.buyerShortName == "BE") {
                    if let id = travellersByNickname["BE"]?.travellerId {
                        cost.buyerId = id
                    }
                }
                if (cost.buyerShortName == "FR") {
                    if let id = travellersByNickname["FR"]?.travellerId {
                        cost.buyerId = id
                    }
                }
            }
        }
    }
    
    init(modelId: String, appId: String, tripIds: [String], deletedTripIds: [String], travellerIds: [String]){
        self.modelId = modelId
        self.appId = appId
        self.tripsUUID = tripIds
        self.deleteTripsUUID = deletedTripIds
    }
    
    //MARK: Save/Load Json
    static let ArchiveJsonURL = Configuration.DocumentsDirectory.appendingPathComponent("model.ctrk")

    func saveModelInJson() {
        if let data = modelToJson(){
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: Model.ArchiveJsonURL.path)
            if isSuccessfulSave {
                os_log("Model successfully saved.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save model...", log: OSLog.default, type: .error)
            }
        }
    }
    
    func loadModelJson() -> Model?  {
        if let jsonData =  NSKeyedUnarchiver.unarchiveObject(withFile: Model.ArchiveJsonURL.path) as? Data{
            return jsonToModel(jsonData: jsonData)
        }
        return nil
    }

    func modelToJson() -> Data?{
        if let jsonData = try? JSONEncoder().encode(self) {
            return jsonData
        }
        return nil
    }
    
    func jsonToModel(jsonData: Data) -> Model?{
        if let decoded = try? JSONDecoder().decode(Model.self, from: jsonData){
            return decoded
        }
        return nil
    }

    func getTraveller(id: String) -> Traveller?{
        return travellers[id]
    }
    
    func tripDidFinish(trip: Trip) {
        DispatchQueue.global(qos: .background).async {
            if trip.isModified {
                trip.isModified = false
                trip.saveTripInJson()

                if !self.tripsUUID.contains(trip.tripId){
                    self.tripsUUID.append(trip.tripId)
                    self.trips.append(trip)
                }
                self.saveModelInJson()
            }
        }
    }
    
    func save(traveller : Traveller) {
        travellers[traveller.travellerId] = traveller
        travellersByNickname[traveller.nickname] = traveller
        self.saveModelInJson()
    }

    func tryRemoveTraveller(travellerId: String) {
        if let traveller = travellers.removeValue(forKey: travellerId) {
            travellersByNickname.removeValue(forKey: traveller.nickname)
            self.saveModelInJson()
            
            for  trip in trips {
                if trip.travellers.removeValue(forKey: travellerId) != nil {
                    tripDidFinish( trip: trip)
                }
            }
        }
    }
    
    func travellerIsUsed(travellerId: String) -> Bool {
        for  trip in trips {
            if trip.travellers.contains(where: {$0.key == travellerId}) {
                return true
            }
        }
        return false
    }
    
    
    // MARK: - Importing
    
    enum  ImportationOption{
        case replace
        case merge
    }
    
    func addTrip(trip: Trip){
        if !tripsUUID.contains(trip.tripId){
            tripsUUID.append(trip.tripId)
        }
        if !trips.contains {$0.tripId == trip.tripId}{
            trips.append(trip)
        }
        addImportedTraveller(travellers: trip.travellers)
        trip.initialize(model: self)
    }
    
    func deleteTrip(id: String){
        deleteTripsUUID.append(id)
        if let index = tripsUUID.index(of: id){
            tripsUUID.remove(at: index)
        }
        
        if let index = (trips.index {$0.tripId == id}) {
            trips.remove(at: index)
        }
    }
    
    func deleteTripAndSave(id: String){
        deleteTrip(id: id)
        saveModelInJson()
    }
    
    func addImportedTraveller(travellers newTravellers: [String:Traveller]?){
        if let newTravellers = newTravellers {
            for traveller in newTravellers{
                if !travellers.keys.contains(traveller.key){
                    self.travellers[traveller.key] = traveller.value
                    self.travellersByNickname[traveller.value.nickname] = traveller.value
                }
            }
        }
    }
    
    func getTrip(id tripId: String) -> Trip?{
        if let trip = (trips.filter {$0.tripId == tripId}).first {
            return trip
        }
        return nil
    }
    
    func addImportedTrip(trip: Trip, option: ImportationOption = .merge ){
        if !self.tripsUUID.contains(trip.tripId){
            self.addTrip(trip: trip)
            trip.saveTripInJson()
        }
        else {
            switch option{
            case .replace:
                deleteTrip(id: trip.tripId )
                addTrip(trip: trip)
                trip.saveTripInJson()
                
            case .merge:
                if let currentTrip = getTrip(id: trip.tripId){
                    //what to do with countries / currencyies / date...
                    //...
                    
                    currentTrip.addImportedCosts(costs: trip.costs)
                    addImportedTraveller(travellers: trip.travellers)
                    currentTrip.saveTripInJson()
                    
                }
                else {
                    self.addTrip(trip: trip)
                    trip.saveTripInJson()
                }
            }
        }
        
        saveModelInJson()
    }
}



