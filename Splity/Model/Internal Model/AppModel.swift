//
//  AppModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 18/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit


class AppModel: BaseModel {
    
    //MARK: Properties
    var tripIds: [UUID] = []
    var deletedTripIds: [UUID] = []
    
    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case tripIds
        case deletedTripIds
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tripIds = try container.decode([UUID].self, forKey: .tripIds)
        self.deletedTripIds = try container.decode([UUID].self, forKey: .deletedTripIds)
        try super.init(from: decoder)
    }
    
    //MARK: Remote Repository
    enum RemoteKey: String {
        case tripIds
        case deletedTripIds
    }
   
    
    override func createRecord() -> CKRecord
    {
        return CKRecord(recordType: CloudKitName.appRecordType, recordID: CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord)
    {
        if let data = record[RemoteKey.tripIds] as? [String] {
                   self.tripIds = data.map{ UUID(uuidString: $0)! }
               }
               if let data = record[RemoteKey.deletedTripIds] as? [String] {
                   self.deletedTripIds = data.map{ UUID(uuidString: $0)! }
               }
        
    }
    
    override func fillRecord(record: CKRecord)
    {
        super.fillRecord(record: record)
        record[RemoteKey.tripIds] = self.tripIds.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.deletedTripIds] = self.deletedTripIds.map{$0.uuidString} as CKRecordValue
        
    }
    
}
