//
//  PaymentParticipationDataModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 18/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//


import UIKit
import os.log
import CloudKit


class PaymentParticipationDataModel: BaseDataModel {
    
    //MARK: Properties
    var ratio:Double?
    var amount:Double?
    var participationType: ParticipationType?
    var costId: UUID?
    
    override init(id: UUID)
    {
        super.init(id: id)
    }
    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case ratio
        case amount
        case participationType
        case costId
    }
    
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ratio, forKey: .ratio)
        try container.encode(amount, forKey: .amount)
        try container.encode(participationType?.int(), forKey: .participationType)
        try container.encode(costId, forKey: .costId)
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ratio = try container.decode(Double?.self, forKey: .ratio)
        self.amount = try container.decode(Double?.self, forKey: .amount)
        self.participationType = try container.decode(ParticipationType.self, forKey: .participationType)
        self.costId = try container.decode(UUID.self, forKey: .costId)
        try super.init(from: decoder)
    }
    
    
    //MARK: Remote Repository
    enum RemoteKey: String {
        case ratio
        case amount
        case participationType
        case costId
        case costReference   
    }
    
    
    override func createRecord() -> CKRecord
    {
        return CKRecord(recordType: CloudKitName.paymentParticipationRecordType, recordID: CKRecordID(recordName: recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord)
    {
        super.fromRecord(record: record)
        
        if let data =  record[RemoteKey.ratio] as? Double {
            self.ratio = data
        }
        else { self.ratio = nil}
        
        if let data = record[RemoteKey.amount] as? Double {
            self.amount = data
        }
        else { self.amount = nil}
        
        
        if let data = record[RemoteKey.participationType] as? Int {
            if let type = ParticipationType.init(rawValue: data){
                self.participationType = type
            }
        }
        
        if let data = record[RemoteKey.costId] as? String {
            if let uuid = UUID(uuidString: data){
                self.costId = uuid
            }
        }
    }
    
    override func fillRecord(record: CKRecord)
    {
        super.fillRecord(record: record)
        
        if let ratio = ratio {
            record[RemoteKey.ratio] = ratio as CKRecordValue
        }
        
        if let amount = amount {
            record[RemoteKey.amount] = amount as CKRecordValue
        }
        
        if let participationType = self.participationType {
            record[RemoteKey.participationType] = participationType.int() as CKRecordValue
        }
        
        
        if let costId = self.costId {
            record[RemoteKey.costId] = costId.uuidString as CKRecordValue
            let costRecordId = CKRecordID(recordName: costId.uuidString, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID)
            let costReference = CKReference(recordID: costRecordId, action: CKReferenceAction.deleteSelf)
            record[RemoteKey.costReference] = costReference as CKRecordValue
            
        }
        
        
    }
}
