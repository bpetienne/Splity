//
//  CostDataModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 12/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit


class CostDataModel: BaseDataModel{
    
    //MARK: Properties
    var name: String?
    var amount: Double?
    var date: Date?
    var categoryType: Category?
    var paymentType: Payment?
    var costType: CostType?
    var currencyCode: String?
    var currencyRateToEuro: Double?
    var payedBy: [UUID] = [UUID]()
    var payedFor: [UUID] = [UUID]()
    var tripId : UUID?
    
   
    override init(id: UUID)
    {
        super.init(id: id)
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
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(categoryType?.int(), forKey: .categoryType)
        try container.encode(paymentType?.int(), forKey: .paymentType)
        try container.encode(costType?.int(), forKey: .costType)
        try container.encode(currencyCode, forKey: .currencyCode)
        try container.encode(currencyRateToEuro, forKey: .currencyRateToEuro)
        try container.encode(payedBy, forKey: .payedBy)
        try container.encode(payedFor, forKey: .payedFor)
        try container.encode(tripId, forKey: .tripId)
        try super.encode(to: encoder)
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
        super.fromRecord(record: record)
        
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
        
        super.fillRecord(record: record)
        
        if let name = self.name {
            record[RemoteKey.name] = name as CKRecordValue
        }
      
        if let amount = self.amount {
            record[RemoteKey.amount] = amount as CKRecordValue
        }
        if let date = self.date {
            record[RemoteKey.date] = date as CKRecordValue
        }
        if let paymentType = self.paymentType {
            record[RemoteKey.paymentType] = paymentType.int() as CKRecordValue
        }
        if let costType = self.costType {
            record[RemoteKey.costType] = costType.int() as CKRecordValue
        }
        
        if let categoryType = self.categoryType {
            record[RemoteKey.categoryType] = categoryType.int() as CKRecordValue
        }
        if let currencyCode = self.currencyCode {
            record[RemoteKey.currencyCode] = currencyCode as CKRecordValue
        }
        if let currencyRateToEuro = self.currencyRateToEuro {
            record[RemoteKey.currencyRateToEuro] = currencyRateToEuro as CKRecordValue
        }
        
        record[RemoteKey.payedBy] = self.payedBy.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.payedFor] = self.payedFor.map{$0.uuidString} as CKRecordValue
        if let tripId = self.tripId {
            record[RemoteKey.tripId] = tripId.uuidString as CKRecordValue
            let tripRecordId = CKRecordID(recordName: tripId.uuidString, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID)
            let tripReference = CKReference(recordID: tripRecordId, action: CKReferenceAction.deleteSelf)
            record[RemoteKey.tripReference] = tripReference as CKRecordValue
            
        }
        
        
    }
    
}
