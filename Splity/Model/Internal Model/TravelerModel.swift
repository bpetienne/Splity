//
//  TravelerMode.swift
//  Splity
//
//  Created by Benoit ETIENNE on 14/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit



class TravelerModel:  BaseModel  {
    
    //MARK: Properties
    var name: String
    var tripId : UUID
    
    //MARK: Initialization
    init?(name:String, tripId:UUID) {
        self.name = name
        self.tripId = tripId
        super.init()
    }

    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case name
        case tripId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.tripId = try container.decode(UUID.self, forKey: .tripId)
        try super.init(from: decoder)
    }
    
    
    
    //MARK: Remote Repository
    enum RemoteKey: String {
                case name
                    case tripId
           case tripReference
          }
    
    override func createRecord() -> CKRecord
    {
        return CKRecord(recordType: CloudKitName.travelerRecordType, recordID: CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord)
    {
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
        record[RemoteKey.name] = self.name as CKRecordValue
        record[RemoteKey.tripId] = self.tripId.uuidString as CKRecordValue
        let tripRecordId = CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID)
        let tripReference = CKReference(recordID: tripRecordId, action: CKReferenceAction.deleteSelf)
        record[RemoteKey.tripReference] = tripReference as CKRecordValue
    }
    
}
