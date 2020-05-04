//
//  TravelerDataModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 14/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit

class TravelerDataModel:  BaseDataModel  {
    
    //MARK: Properties
    var name: String?
    var tripId : UUID?
    
    override init(id: UUID)
    {
        super.init(id: id)
    }
    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case name
        case tripId
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(tripId, forKey: .tripId)
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String?.self, forKey: .name)
        self.tripId = try container.decode(UUID?.self, forKey: .tripId)
        try super.init(from: decoder)
    }
    
    
    
    //MARK: Remote Repository
    enum RemoteKey: String {
        case name
        case tripId
        case tripReference
    }
    
    internal override func createRecord() -> CKRecord
    {
        return CKRecord(recordType: CloudKitName.travelerRecordType, recordID: CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord)
    {
        super.fromRecord(record: record)

        if let data = record[RemoteKey.name] as? String {
            self.name = data
        }
        
        if let data = record[RemoteKey.tripId] as? String {
            if let uuid = UUID(uuidString: data){
                self.tripId = uuid
            }
        }
        
        //todo
        //tripReference?
        
    }
    
    override func fillRecord(record: CKRecord)
    {
        super.fillRecord(record: record)
        
        if let name = self.name {
            record[RemoteKey.name] = name as CKRecordValue
        }
        
        
        if let tripId = self.tripId {
            record[RemoteKey.tripId] = tripId.uuidString as CKRecordValue
            let tripRecordId = CKRecordID(recordName: tripId.uuidString, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID)
            let tripReference = CKReference(recordID: tripRecordId, action: CKReferenceAction.deleteSelf)
            record[RemoteKey.tripReference] = tripReference as CKRecordValue
        }
        
    }
    
}
