//
//  LocalRepository.swift
//  Splity
//
//  Created by Benoit ETIENNE on 19/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//


import Foundation
import os.log
import CloudKit
import UIKit
import CoreLocation


protocol Repository {
    
    func queryItems (_ page: Int, completion: @escaping ([BaseDataModel], NSError?) -> Void)
    func queryUnsyncedItems() -> [BaseDataModel]
    func queryDeletedItems (_ completion: @escaping ([BaseDataModel]) -> Void)
    func queryUpdates (sinceDate: Date, completion: @escaping ([BaseDataModel], [String], NSError?) -> Void)
    // Marks the Task as deleted. If forceDelete is true it will be removed from db
    func deleteItem (_ item: BaseDataModel, forceDelete: Bool, completion: @escaping ((_ success: Bool) -> Void))
    func deleteItem (objectId: String, completion: @escaping ((_ success: Bool) -> Void))
    // Save a task and returns the same task with a taskId generated if it didn't had
    func saveItem (_ item: BaseDataModel, completion: @escaping ((_ item: BaseDataModel) -> Void))
}


class LocalDataRepository /*: Repository*/ {
    
    
    func loadData() -> Model?{
        
        let model = Model()
        guard let internalModel: ApplicationDataModel = load() else {return nil}
        
        for tripId in internalModel.tripIds {
            
            if let trip = loadTrip(id: tripId){
                model.trips[tripId] = trip
            }
        }
        
        return model
    }
    
    
    func loadTrip(id: UUID) -> Trip?
    {
        if let tripModel: TripDataModel = load(id){
            let trip = Trip().fromInternalModel(internalModel: tripModel)
            
            for travelerId in tripModel.travelerIds {
                if let travelerModel: TravelerDataModel = load(id){
                    trip.travelers[travelerId] = Traveler().fromInternalModel(internalModel: travelerModel)
                }
            }
            
            for costId in tripModel.costIds {
                if let cost = loadCost(id: costId) {
                    trip.costs.append(cost)
                }
            }
            return trip
        }
        
        return nil
    }
    
    func loadCost(id: UUID) -> Cost?
    {
        if let costModel: CostDataModel = load(id){
            
            let cost = Cost().fromInternalModel(internalModel: costModel)
            
            for paymentParticipationId in costModel.payedBy {
                if let paymentParticipationModel: PaymentParticipationDataModel = load(paymentParticipationId){
                    cost.payedBy[paymentParticipationId] = PaymentParticipation().fromInternalModel(internalModel: paymentParticipationModel)
                }
            }
            
            for paymentParticipationId in costModel.payedFor {
                if let paymentParticipationModel: PaymentParticipationDataModel = load(paymentParticipationId){
                    cost.payedFor[paymentParticipationId] = PaymentParticipation().fromInternalModel(internalModel: paymentParticipationModel)
                }
            }
            
            return cost
        }
        
        return nil
    }
    
    
    func load<T: LocalProtocol>(_ uuid: UUID? = nil) -> T?{
        guard let url = T.getArchivedUrl(uuid, "\(type(of: self))") else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {return nil}
        return decoded
    }

    func save<T: LocalProtocol>(_ codable: T) {
        guard let url = codable.archivedUrl else { return }
        guard let data = try? JSONEncoder().encode(codable) else {return }
        try? data.write(to: url)
    }
    
    
    func queryItems(_ page: Int, completion: @escaping ([BaseDataModel], NSError?) -> Void) {

    }

    func queryUnsyncedItems() -> [Trip] {
        if let myappModel = ModelManager.appModel {

            let myTrips =  myappModel.trips.map{$0.value}.filter{$0.isLocallyUpdated}            
            return myTrips
        }
        return [Trip]()
    }
            

    func queryDeletedItems(_ completion: @escaping ([BaseDataModel]) -> Void) {
//        completion(ModelManager.model.items.map {$0.value}.filter {$0.isDeleted})
        //or
        //completion(ModelManager.model.deletedItems.map {$0.value})
    }

    func queryUpdates(sinceDate: Date, completion: @escaping ([BaseDataModel], [String], NSError?) -> Void) {

    }

    func deleteItem(_ item: BaseDataModel, forceDelete: Bool, completion: @escaping ((Bool) -> Void)) {
        guard let url = item.archivedUrl else {
            completion(false)
            return  }
        do {
            try FileManager.default.removeItem(at: url)
            completion(true)

        }
        catch{
            completion(false)
        }
    }

    func deleteItem(objectId: String, completion: @escaping ((Bool) -> Void)) {

    }

    func saveItem(_ item: BaseDataModel, completion: @escaping ((BaseDataModel) -> Void)) {
        save(item)
        completion(item)
    }
}
