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
    
    func queryItems (_ page: Int, completion: @escaping ([BaseModel], NSError?) -> Void)
    func queryUnsyncedItems() -> [BaseModel]
    func queryDeletedItems (_ completion: @escaping ([BaseModel]) -> Void)
    func queryUpdates (sinceDate: Date, completion: @escaping ([BaseModel], [String], NSError?) -> Void)
    // Marks the Task as deleted. If forceDelete is true it will be removed from db
    func deleteItem (_ item: BaseModel, forceDelete: Bool, completion: @escaping ((_ success: Bool) -> Void))
    func deleteItem (objectId: String, completion: @escaping ((_ success: Bool) -> Void))
    // Save a task and returns the same task with a taskId generated if it didn't had
    func saveItem (_ item: BaseModel, completion: @escaping ((_ item: BaseModel) -> Void))
}


class LocalDataRepository /*: Repository*/ {
    
    
//    func loadData() -> Model?{
//
//        guard let model: Model = load() else {return nil}
//
//        for itemId in model.itemIds {
//            if let item: Item = load(itemId){
//                model.items[item.id] = item
//            }
//        }
//
//        for itemId in model.deletedItemIds {
//            if let item: Item = load(itemId){
//                model.deletedItems[item.id] = item
//            }
//        }
//
//        return model
//    }
    
    func load<T: LocalProtocol>(_ uuid: UUID? = nil) -> T?{
        guard let url = T.getArchivedUrl(uuid) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {return nil}
        return decoded
    }

    func save<T: LocalProtocol>(_ codable: T) {
        guard let url = codable.archivedUrl else { return }
        guard let data = try? JSONEncoder().encode(codable) else {return }
        try? data.write(to: url)
    }
    
    
//    func queryItems(_ page: Int, completion: @escaping ([BaseModel], NSError?) -> Void) {
//
//    }
//
//    func queryUnsyncedItems() -> [BaseModel] {
//
//        return ModelManager.model.items.map {$0.value}.filter {$0.isLocallyUpdated}
//    }
//
//    func queryDeletedItems(_ completion: @escaping ([BaseModel]) -> Void) {
////        completion(ModelManager.model.items.map {$0.value}.filter {$0.isDeleted})
//        completion(ModelManager.model.deletedItems.map {$0.value})
//    }
//
//    func queryUpdates(sinceDate: Date, completion: @escaping ([BaseModel], [String], NSError?) -> Void) {
//
//    }
//
//    func deleteItem(_ item: BaseModel, forceDelete: Bool, completion: @escaping ((Bool) -> Void)) {
//        guard let url = item.archivedUrl else {
//            completion(false)
//            return  }
//        do {
//            try FileManager.default.removeItem(at: url)
//            completion(true)
//
//        }
//        catch{
//            completion(false)
//        }
//    }
//
//    func deleteItem(objectId: String, completion: @escaping ((Bool) -> Void)) {
//
//    }
//
//    func saveItem(_ item: BaseModel, completion: @escaping ((Item) -> Void)) {
//        save(item)
//        completion(item)
//    }
}
