//
//  TripCloudRequest.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 08/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import Foundation
import CloudKit
import UIKit




class ModelCloudRequest: NSObject{

    
    internal let privateDatabase = CKContainer.default().privateCloudDatabase
    internal let customZone = CKRecordZone(zoneName: "CostTrackerCustomZone")
    
    func createCustomZone(completionClosure: @escaping (String) -> ()) {
        privateDatabase.save(customZone) { (recordZone, error) -> Void in
            DispatchQueue.main.sync {
                // Dismiss Progress HUD
                //SVProgressHUD.dismiss()
                
                // Process Response
                self.processResponse(recordZone: recordZone, error: error, completionClosure: completionClosure)
            }
            
        }
        //SVProgressHUD.show()
        
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func processResponse(recordZone: CKRecordZone?, error: Error?, completionClosure: (String) -> ()) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We were not able to save your list."
            
        } else if recordZone == nil {
            message = "We were not able to save your list."
        }
        print(message)

        completionClosure(message)

//        if !message.isEmpty {
//
//            // Initialize Alert Controller
//
//            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//
//            // Present Alert Controller
//            present
//            present(alertController, animated: true, completion: nil)
//        }
    }
    
    
    
    func fetchTrips() {
        // Fetch Private Database
        var trips = [Trip]()
        
        // Initialize Query
        let query = CKQuery(recordType: "Trip", predicate: NSPredicate(value: true))
        
        // Configure Query
        query.sortDescriptors = [NSSortDescriptor(key: "Name", ascending: true)]
        
        // Perform Query
        
        privateDatabase.perform(query, inZoneWith: customZone.zoneID) { (records, error) -> Void in
            DispatchQueue.main.sync {
                self.processResponseForQuery(records, error: error)
            }
        }
        
        
//        privateDatabase.perform(query, inZoneWith: customZone.zoneID) { (records, error) in
//            records?.forEach({ (record) in
//                
//                guard error == nil else{
//                    print(error?.localizedDescription as Any)
//                    return
//                }
//                
//                print(record.value(forKey: "name") ?? "")
//                
//                let trip = Trip()
//                trip.fromRecord(record: record)
//                trips.append(trip)
////                DispatchQueue.main.sync {
////                    self.tableView.reloadData()
////                    self.messageLabel.text = ""
////                    self.updateView()
////                }
//            })
//            
//        }
    }
    
    
    private func processResponseForQuery(_ records: [CKRecord]?, error: Error?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "Error Fetching Items for List"
            
        } else if let records = records {
            let items = records
            
            for itemsingle in items {
                let trip = Trip()
                trip.fromRecord(record: itemsingle)
                //trips.append(trip)
            }
            if items.count == 0 {
                message = "No Items Found"
            }
            
        } else {
            message = "No Items Found"
        }
        
//        if message.isEmpty {
//            tableView.reloadData()
//        } else {
//            messageLabel.text = message
//        }
        
        print(message)
        
    }
    
    
    
    func save(trip: Trip, completionClosure: @escaping (String) -> ()) {
        
        let record = trip.toRecord()
        
        // Fetch Private Database
     
        // Show Progress HUD
        //SVProgressHUD.show()
        
        // Save Record
        privateDatabase.save(record) { (record, error) -> Void in
            DispatchQueue.main.sync {
                // Dismiss Progress HUD
                //SVProgressHUD.dismiss()
                
                // Process Response
                self.processResponse(record: record, error: error, completionClosure: completionClosure)
            }
            
        }
    }
    
    
    // MARK: -
    // MARK: Helper Methods
    private func processResponse(record: CKRecord?, error: Error?, completionClosure: (String) -> ()) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We were not able to save your list."
            
        } else if record == nil {
            message = "We were not able to save your list."
        }
        print(message)

        completionClosure(message)
        
//        if !message.isEmpty {
//            // Initialize Alert Controller
//            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//
//            // Present Alert Controller
//            present(alertController, animated: true, completion: nil)
//
//        } else {
//            // Notify Delegate
//            if newItem {
//                delegate?.controller(controller: self, didAddItem: item!)
//            } else {
//                delegate?.controller(controller: self, didUpdateItem: item!)
//            }
//
//            // Pop View Controller
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    var item: CKRecord?

    
    func fetchShare(_ cloudKitShareMetadata: CKShareMetadata){
        let op = CKFetchRecordsOperation(recordIDs: [cloudKitShareMetadata.rootRecordID])
        op.perRecordCompletionBlock = { record, _, error in
            guard error == nil, record != nil else{
                print("error \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.item = record
            }
        }
        op.fetchRecordsCompletionBlock = { _, error in
            guard error != nil else{
                print("error \(error?.localizedDescription ?? "")")
                return
            }
        }
        CKContainer.default().sharedCloudDatabase.add(op)
    }
    
    
}





















class TripCloudRequest: NSObject{
    let container : CKContainer
    let publicDB : CKDatabase
    let privateDB : CKDatabase
    let sharedDB : CKDatabase

    var delegate: ModelDelegate1?
    var items: [Trip] = []
    var costs: [String:Cost] = [:]
    var travellers: [String:Traveler] = [:]
    
    

    
    // Use a consistent zone ID across the user's devices
    // CKCurrentUserDefaultName specifies the current user's ID when creating a zone ID
    let zoneID = CKRecordZoneID(zoneName: "CostTrackerCustomZone", ownerName: CKCurrentUserDefaultName)
    let sharedZoneID = CKRecordZoneID(zoneName: "CostTrackerCustomSharedZone", ownerName: CKCurrentUserDefaultName)

    
    // Store these to disk so that they persist across launches
    var createdCustomZone = false
    var subscribedToPrivateChanges = false
    var subscribedToSharedChanges = false
    
    let privateSubscriptionId = "private-changes"
    let sharedSubscriptionId = "shared-changes"
    
    
    var databaseChangeToken:CKServerChangeToken?
    var zoneChangeToken:CKServerChangeToken?
    

    
    init (databaseChangeToken: CKServerChangeToken?,zoneChangeToken:CKServerChangeToken?)
    {
        self.databaseChangeToken = databaseChangeToken
        self.zoneChangeToken = zoneChangeToken
        
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase

    }
    
    override init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
        
        
        
    }
    
    func queryBatch(type:String){
        var allRecords: [CKRecord] = []
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = { (record: CKRecord) in
            allRecords.append(record)
        }
        
        //operation.queryCompletionBlock = ttest
        operation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: Error?) in
            // There is another batch of records to be fetched
            if let cursor = cursor {
                self.queryBatch(type:type, cursor:cursor,records:allRecords)
            }
                // There was an error
            else if let error = error {
                self.delegate?.errorUpdating(error: error as Error)
                print("Error for \(type) query:", error)
            }
                // No error and no cursor means the operation was successful
            else {
                print("Finished with records \(type)")
                DispatchQueue.main.async {
                    self.delegate?.modelUpdated(type: type,records: allRecords, database: self.publicDB)
                }
            }
        }
        self.publicDB.add(operation)
    }
    
    var allCurrentRecords = [CKRecord]()
    /*var ttest : (CKQueryCursor?, Error?) -> Void  = { (cursor: CKQueryCursor?, error: Error?) in
        // There is another batch of records to be fetched
        if let cursor = cursor {
            self.queryBatch(type:type, cursor:cursor,records:allCurrentRecords)
        }
            // There was an error
        else if let error = error {
            self.delegate?.errorUpdating(error: error as Error)
            print("Error for \(type) query:", error)
        }
            // No error and no cursor means the operation was successful
        else {
            print("Finished with records \(type)")
            DispatchQueue.main.async {
                self.delegate?.modelUpdated(type: type,records: allCurrentRecords, database: self.publicDB)
            }
        }
    }*/

    
    
    
    func queryBatch(type:String, cursor: CKQueryCursor, records: [CKRecord]){
        var allRecords = records

        let operation = CKQueryOperation(cursor: cursor)
        operation.recordFetchedBlock = { (record: CKRecord) in
            allRecords.append(record)
        }
        operation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: Error?) in
            // There is another batch of records to be fetched
            if let cursor = cursor {
                self.queryBatch(type:type, cursor:cursor,records:allRecords)
            }
                // There was an error
            else if let error = error {
                self.delegate?.errorUpdating(error: error as Error)
                print("Error for \(type) query:", error)
            }
                // No error and no cursor means the operation was successful
            else {
                print("Finished with records:", allRecords)
                DispatchQueue.main.async {
                    self.delegate?.modelUpdated(type: type,records: allRecords, database: self.publicDB)
                }
            }
        }
        self.publicDB.add(operation)
    }

    
    
    
    
    
    
    
    
    func saveRecord(record: CKRecord){
        publicDB.save(record) {
            (record, error) in
            if let error = error {
                // Insert error handling
                print("Cloud Query Error - Fetch Trips: \(error)")

                return
            }
            else {
                
            }
            // Insert successfully saved record code
        }
    }
     func updateRecord(records: [CKRecord])  {
        
        let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)

        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10
        
        modifyRecordsOperation.modifyRecordsCompletionBlock =
            { records, recordIDs, error in
                if let error = error {
                    print("Cloud Update Error - Update Trip: \(error)")
                    
                    
                } else {
                    print("Success Update Trip on iCloud")
                    
                }
        }
        
        privateDB.add(modifyRecordsOperation)
    }
    
    func updateRecordWithBatch(records: [CKRecord]){
        var recordsTosave = [CKRecord]()
        for record in records{
            recordsTosave.append(record)

            if recordsTosave.count >= 300 {
                updateRecord(records: recordsTosave)
                recordsTosave.removeAll()
            }
        }
        
        if recordsTosave.count > 0{
            updateRecord(records: recordsTosave)
            recordsTosave.removeAll()
        }
    }
    
    func deleteRecords(records: [CKRecord]){
        
        let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: records.map{$0.recordID})
        
        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10
        
        modifyRecordsOperation.modifyRecordsCompletionBlock =
            { records, recordIDs, error in
                if let error = error {
                    print("Cloud delete Error: \(error)")
                    
                } else {
                    print("Success delete")
                    
                }
        }
        
        
        publicDB.add(modifyRecordsOperation)
    }
    
    func delete(type:String)
    {
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        publicDB.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error: error as NSError)
                    print("Cloud Query Error - Fetch travellers: \(error)")
                }
                return
            }
            var items = [CKRecord]()
            results?.forEach({ (record: CKRecord) in
                items.append(record)
            })
            DispatchQueue.main.async {
                self.deleteRecords(records: items)
            }
        }
    }
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    func createCustomZonePerso(){
        let createZoneGroup = DispatchGroup()
        
        if !self.createdCustomZone {
            createZoneGroup.enter()
            
            let customZone = CKRecordZone(zoneID: zoneID)
            
            let createZoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: [customZone], recordZoneIDsToDelete: [] )
            
            createZoneOperation.modifyRecordZonesCompletionBlock = { (saved, deleted, error) in
                if (error == nil) { self.createdCustomZone = true }
                // else custom error handling
                createZoneGroup.leave()
            }
            createZoneOperation.qualityOfService = .userInitiated
            
            self.privateDB.add(createZoneOperation)

            
        }
    }
    
    
    func createCustomZoneShared(){
        let createZoneGroup = DispatchGroup()
        
        if !self.createdCustomZone {
            createZoneGroup.enter()
            
            
            let customZone = CKRecordZone(zoneID: sharedZoneID)
        
            let createZoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: [customZone], recordZoneIDsToDelete: [] )
            
            createZoneOperation.modifyRecordZonesCompletionBlock = { (saved, deleted, error) in
                if (error == nil) { self.createdCustomZone = true }
                else {
                    print("Error during shared zone creation", error!)

                }
                // else custom error handling
                createZoneGroup.leave()
            }
            createZoneOperation.qualityOfService = .userInitiated
            
            self.sharedDB.add(createZoneOperation)
            
            
        }
    }

    
    func subscribeToChangeNotifications(){
        let createZoneGroup = DispatchGroup()

        if !self.subscribedToPrivateChanges {
            let createSubscriptionOperation = self.createDatabaseSubscriptionOperation(subscriptionId: privateSubscriptionId)
            createSubscriptionOperation.modifySubscriptionsCompletionBlock = { (subscriptions, deletedIds, error) in
                if error == nil { self.subscribedToPrivateChanges = true }
                // else custom error handling
            }
            self.privateDB.add(createSubscriptionOperation)
        }
        
        if !self.subscribedToSharedChanges {
            let createSubscriptionOperation = self.createDatabaseSubscriptionOperation(subscriptionId: sharedSubscriptionId)
            createSubscriptionOperation.modifySubscriptionsCompletionBlock = { (subscriptions, deletedIds, error) in
                if error == nil { self.subscribedToSharedChanges = true }
                // else custom error handling
            }
            self.sharedDB.add(createSubscriptionOperation)
        }
        
        // Fetch any changes from the server that happened while the app wasn't running
        createZoneGroup.notify(queue: DispatchQueue.global()) {
            if self.createdCustomZone {
                self.fetchChanges(in: .private) {}
                self.fetchChanges(in: .shared) {}
            }
        }
    }
    
    
    func createDatabaseSubscriptionOperation(subscriptionId: String) -> CKModifySubscriptionsOperation {
        let subscription = CKDatabaseSubscription.init(subscriptionID: subscriptionId)
        
        let notificationInfo = CKNotificationInfo()
        // send a silent notification
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
        operation.qualityOfService = .utility
        
        return operation
    }

    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification!")
        
        let dict = userInfo as! [String: NSObject]
        guard let notification:CKDatabaseNotification = CKNotification(fromRemoteNotificationDictionary:dict) as? CKDatabaseNotification else { return }
        
        self.fetchChanges(in: notification.databaseScope) {
            completionHandler(.newData)
        }
    }

    
    /*
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     application.registerForRemoteNotifications()
     return true
     }

     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification!")
        
        let viewController = self.window?.rootViewController as? UIViewController
        guard let viewController = self.window?.rootViewController as? UIViewController else { return }
        
        let dict = userInfo as! [String: NSObject]
        guard let notification:CKDatabaseNotification = CKNotification(fromRemoteNotificationDictionary:dict) as? CKDatabaseNotification else { return }
        
        viewController!.fetchChanges(in: notification.databaseScope) {
            completionHandler(.newData)
        }
    }*/

    
    func askForLastChanges(completion: @escaping () -> Void){
        self.fetchChanges(in: .private) {completion()}

        //self.fetchChanges(in: .shared) {completion()}


    }
    
    func fetchChanges(in databaseScope: CKDatabaseScope, completion: @escaping () -> Void) {
        switch databaseScope {
        case .private:
            fetchZoneChanges(database: self.privateDB, databaseTokenKey:  "private", zoneID: zoneID, completion: completion)
        case .shared:
            fetchZoneChanges(database: self.sharedDB, databaseTokenKey:  "shared", zoneID: sharedZoneID, completion: completion)
        case .public:
            fatalError()
        }
    }

    
    func fetchChangesOld(in databaseScope: CKDatabaseScope, completion: @escaping () -> Void) {
        switch databaseScope {
        case .private:
            fetchDatabaseChanges(database: self.privateDB, databaseTokenKey: "private", completion: completion)
        case .shared:
            fetchDatabaseChanges(database: self.sharedDB, databaseTokenKey: "shared", completion: completion)
        case .public:
            fatalError()
        }
    }
    
    
    
    func fetchDatabaseChanges(database: CKDatabase, databaseTokenKey: String, completion: @escaping () -> Void) {
        var changedZoneIDs: [CKRecordZoneID] = []
        
        let changeToken = self.databaseChangeToken // Read change token from disk
        
    
        let operation = CKFetchDatabaseChangesOperation(previousServerChangeToken: changeToken)
        
        operation.recordZoneWithIDChangedBlock = { (zoneID) in
            changedZoneIDs.append(zoneID)
            
        }
        
        operation.recordZoneWithIDWasDeletedBlock = { (zoneID) in
            // Write this zone deletion to memory
        }
        
        operation.changeTokenUpdatedBlock = { (token) in
            // Flush zone deletions for this database to disk
            // Write this new database change token to memory
            self.databaseChangeToken = token

        }
        
        operation.fetchDatabaseChangesCompletionBlock = { (token, moreComing, error) in
            if let error = error {
                print("Error during fetch shared database changes operation", error)
                completion()
                return
            }
            // Flush zone deletions for this database to disk
            // Write this new database change token to memory
            self.databaseChangeToken = token!

            
            self.fetchZoneChanges(database: database, databaseTokenKey: databaseTokenKey, zoneIDs: changedZoneIDs) {
                // Flush in-memory database change token to disk
                completion()
            }
        }
        operation.qualityOfService = .userInitiated
        

        database.add(operation)
    }
 
    
    func fetchZoneChanges(database: CKDatabase, databaseTokenKey: String, zoneIDs: [CKRecordZoneID], completion: @escaping () -> Void) {
        
        // Look up the previous change token for each zone
        var optionsByRecordZoneID = [CKRecordZoneID: CKFetchRecordZoneChangesOptions]()
        for zoneID in zoneIDs {
            let options = CKFetchRecordZoneChangesOptions()
            options.previousServerChangeToken = zoneChangeToken // Read change token from disk

                optionsByRecordZoneID[zoneID] = options
        }
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: zoneIDs, optionsByRecordZoneID: optionsByRecordZoneID)

        
        operation.recordChangedBlock = { (record) in
            print("Record changed:", record)
            // Write this record change to memory
            self.allCurrentRecords.append(record)
        }
        
        operation.recordWithIDWasDeletedBlock = { recordId, data in
            print("Record deleted:", recordId)
            // Write this record deletion to memory
        }
        
        operation.recordZoneChangeTokensUpdatedBlock = { (zoneId, token, data) in
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
            self.zoneChangeToken = token!
            

        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
                return
            }
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
            
            self.zoneChangeToken = changeToken
            
        }
        
        operation.fetchRecordZoneChangesCompletionBlock = { (error) in
            if let error = error {
                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
            }
            completion()
        }
        
        database.add(operation)
    }
    
    
    
    
    
    
    
    
    
    func fetchZoneChanges(database: CKDatabase, databaseTokenKey: String, zoneID: CKRecordZoneID, completion: @escaping () -> Void) {
        
        // Look up the previous change token for each zone
        let options = CKFetchRecordZoneChangesOptions()
        options.previousServerChangeToken = zoneChangeToken // Read change token from disk
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [zoneID], optionsByRecordZoneID: [zoneID:options])
        
        operation.recordChangedBlock = { (record) in
            print("Record changed:", record)
            // Write this record change to memory
            self.allCurrentRecords.append(record)
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordId, data) in
            print("Record deleted:", recordId)
            // Write this record deletion to memory
        }
        
        operation.recordZoneChangeTokensUpdatedBlock = { (zoneId, token, data) in
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
            self.zoneChangeToken = token!
            
            
        }
        
        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
            if let error = error {
                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
                return
            }
            // Flush record changes and deletions for this zone to disk
            // Write this new zone change token to disk
            
            self.zoneChangeToken = changeToken
            
        }
        
        operation.fetchRecordZoneChangesCompletionBlock = { (error) in
            if let error = error {
                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
            }
            completion()
        }
        
        database.add(operation)
    }

    
 /*
    
    func requestTravellers(){
        let query = CKQuery(recordType: "Traveller", predicate: NSPredicate(value: true))
        
        
        publicDB.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error: error as Error)
                    print("Cloud Query Error - Fetch travellers: \(error)")
                }
                return
            }
            self.travellers.removeAll()
            results?.forEach({ (record: CKRecord) in
                if let traveller = Traveller(record: record, database: self.publicDB){
                    self.travellers[traveller.travellerId]=traveller
                }
            })
            DispatchQueue.main.async {
                self.requestCosts()
            }
        }
    }
    func requestCosts(){
        let queryCosts = CKQuery(recordType: "Cost", predicate: NSPredicate(value: true))
        
        publicDB.perform(queryCosts, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error: error as NSError)
                    print("Cloud Query Error - Fetch Costs: \(error)")
                }
                return
            }
            
            self.costs.removeAll()
            results?.forEach({ (record: CKRecord) in
                if let cost = Cost(record: record, database: self.publicDB){
                    self.costs[cost.costId]=cost
                }
            })
            DispatchQueue.main.async {
                self.requestTrips()
            }
        }
    }
    
    
    func requestTrips(){
        let queryTrips = CKQuery(recordType: "Trip", predicate: NSPredicate(value: true))
        
        publicDB.perform(queryTrips, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error: error as NSError)
                    print("Cloud Query Error - Fetch Trips: \(error)")
                }
                return
            }
            self.items.removeAll()
            results?.forEach({ (record: CKRecord) in
                if let trip = Trip(record: record, database: self.publicDB){
                    for costId in trip.costIds{
                        if let cost = self.costs[costId]{
                            trip.costs.append(cost)
                            
                        }
                    }
                    self.items.append(trip)
                }
            })
            DispatchQueue.main.async {
                self.delegate?.modelUpdated()
            }
        }
        
        
    }

    
     
     */
    
    
}
