//
//  CostModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 12/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit


class CostModel: BaseModel{
    
    //MARK: Properties
    var name: String
    var amount: Double
    var date: Date
    var categoryType: Category?
    var paymentType: Payment
    var costType: CostType = CostType.Expenditure
    var currencyCode: String
    var currencyRateToEuro: Double
    var payedBy: [UUID]
    var payedFor: [UUID]
    var tripId : UUID
    
    //MARK: Initialization
    init?(name: String,  amount: Double, categoryType: Category?, date: Date, paymentType: Payment, costType: CostType, currencyCode: String,currencyRateToEuro: Double, payedBy: [UUID], payedFor: [UUID], tripId: UUID) {
        
        self.name = name
        self.amount = amount
        self.date = date
        self.categoryType = categoryType
        self.paymentType = paymentType
        self.costType = costType
        self.currencyCode = currencyCode
        self.currencyRateToEuro = currencyRateToEuro
        self.payedBy = payedBy
        self.payedFor = payedFor
        self.tripId = tripId
        super.init()
    }
    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case name
        case amount
        case date
        case categoryType
        case paymentType
        case costType
        case currencyCode
        case currencyRateToEuro
        case payedBy
        case payedFor
        case tripId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.date = try container.decode(Date.self, forKey: .date)
        self.categoryType = try Category.init(rawValue: container.decode(Int.self, forKey: .categoryType))
        self.paymentType = try (Payment.init(rawValue: container.decode(Int.self, forKey: .paymentType)) ?? Payment.Card)
        self.costType = try (CostType.init(rawValue: container.decode(Int.self, forKey: .costType)) ?? CostType.Expenditure)
        self.currencyCode = try container.decode(String.self, forKey: .currencyCode)
        self.currencyRateToEuro = try container.decode(Double.self, forKey: .currencyRateToEuro)
        self.payedBy = try container.decode([UUID].self, forKey: .payedBy)
        self.payedFor = try container.decode([UUID].self, forKey: .payedFor)
        self.tripId = try container.decode(UUID.self, forKey: .tripId)
        
        try super.init(from: decoder)
    }
    
    
    
    
    //MARK: Remote Repository
    
     enum RemoteKey: String {
           case name
           case amount
           case date
           case categoryType
           case paymentType
           case costType
           case currencyCode
           case currencyRateToEuro
           case payedBy
           case payedFor
           case tripId
        case tripReference
       }
   

     func getRecordId() -> CKRecordID
    {
        CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID)
    }
    
    
    override func createRecord() -> CKRecord
    {
        CKRecord(recordType: CloudKitName.costRecordType, recordID: CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord) {
        if let data = record[RemoteKey.name] as? String {
            self.name = data
        }
        
        if let data = record[RemoteKey.amount]as? Double {
            self.amount = data
        }
        
        if let data = record[RemoteKey.date] as? Date {
            self.date = data
        }
        
        if let data = record[RemoteKey.paymentType] as? Int {
            if let type = Payment.init(rawValue: data){
                self.paymentType = type
            }
        }
        
        if let data = record[RemoteKey.costType] as? Int {
            if let type = CostType.init(rawValue: data){
                self.costType = type
            }
        }
        
        if let data = record[RemoteKey.categoryType] as? Int {
            if let type = Category.init(rawValue: data){
                self.categoryType = type
            }
        }
        
        if let data = record[RemoteKey.currencyCode] as? String {
            self.currencyCode = data
        }
        
        if let data = record[RemoteKey.currencyRateToEuro] as? Double {
            self.currencyRateToEuro = data
        }
        
        if let data = record[RemoteKey.payedBy] as? [String] {
            self.payedBy = data.map{ UUID(uuidString: $0)! }
        }
        if let data = record[RemoteKey.payedFor] as? [String] {
            self.payedFor = data.map{ UUID(uuidString: $0)! }
        }
        
        if let data = record[RemoteKey.tripId] as? String {
            if let uuid = UUID(uuidString: data){
                self.tripId = uuid
            }
        }
        
        //todo
        //tripReference
    }
    
    override func fillRecord(record: CKRecord) {
        
        record[RemoteKey.name] = self.name as CKRecordValue
        record[RemoteKey.amount] = self.amount as CKRecordValue
        record[RemoteKey.date] = self.date as CKRecordValue
        record[RemoteKey.paymentType] = self.paymentType.int() as CKRecordValue
        record[RemoteKey.costType] = self.costType.int() as CKRecordValue
        if let categoryType = self.categoryType {
            record[RemoteKey.categoryType] = categoryType.int() as CKRecordValue
        }
        record[RemoteKey.currencyCode] = self.currencyCode as CKRecordValue
        record[RemoteKey.currencyRateToEuro] = self.currencyRateToEuro as CKRecordValue
        record[RemoteKey.payedBy] = self.payedBy.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.payedFor] = self.payedFor.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.tripId] = self.tripId.uuidString as CKRecordValue
        let tripRecordId = CKRecordID(recordName: self.tripId.uuidString, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID)
        let tripReference = CKReference(recordID: tripRecordId, action: CKReferenceAction.deleteSelf)
        record[RemoteKey.tripReference] = tripReference as CKRecordValue
        
    }
    
}
