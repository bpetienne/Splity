//
//  ApplicationDataModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 18/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit


class ApplicationDataModel: BaseDataModel {
    
    //MARK: Properties
    var tripIds: [UUID] = []
    var deletedTripIds: [UUID] = []
    var costIds: [UUID] = []
    var travelerIds: [UUID] = []
    var paymentParticipationIds: [UUID] = []
    
    override init(id: UUID)
    {
        super.init(id: id)
    }
    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case tripIds
        case deletedTripIds
        case costIds
        case travelerIds
        case paymentParticipationIds
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tripIds, forKey: .tripIds)
        try container.encode(deletedTripIds, forKey: .deletedTripIds)
        try container.encode(costIds, forKey: .costIds)
        try container.encode(travelerIds, forKey: .travelerIds)
        try container.encode(paymentParticipationIds, forKey: .paymentParticipationIds)
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tripIds = try container.decode([UUID].self, forKey: .tripIds)
        self.deletedTripIds = try container.decode([UUID].self, forKey: .deletedTripIds)
        self.costIds = try container.decode([UUID].self, forKey: .costIds)
        self.travelerIds = try container.decode([UUID].self, forKey: .travelerIds)
        self.paymentParticipationIds = try container.decode([UUID].self, forKey: .paymentParticipationIds)
        
        try super.init(from: decoder)
    }
    
    //MARK: Remote Repository
    enum RemoteKey: String {
        case tripIds
        case deletedTripIds
        case costIds
        case travelerIds
        case paymentParticipationIds
    }
    
    
    override func createRecord() -> CKRecord
    {
        return CKRecord(recordType: CloudKitName.appRecordType, recordID: CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord)
    {
        super.fromRecord(record: record)

        if let data = record[RemoteKey.tripIds] as? [String] {
            self.tripIds = data.map{ UUID(uuidString: $0)! }
        }
        if let data = record[RemoteKey.deletedTripIds] as? [String] {
            self.deletedTripIds = data.map{ UUID(uuidString: $0)! }
        }
        if let data = record[RemoteKey.costIds] as? [String] {
            self.costIds = data.map{ UUID(uuidString: $0)! }
        }
        if let data = record[RemoteKey.travelerIds] as? [String] {
            self.travelerIds = data.map{ UUID(uuidString: $0)! }
        }
        if let data = record[RemoteKey.paymentParticipationIds] as? [String] {
            self.paymentParticipationIds = data.map{ UUID(uuidString: $0)! }
        }
        
    }
    
    override func fillRecord(record: CKRecord)
    {
        super.fillRecord(record: record)
        record[RemoteKey.tripIds] = self.tripIds.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.deletedTripIds] = self.deletedTripIds.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.costIds] = self.costIds.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.travelerIds] = self.travelerIds.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.paymentParticipationIds] = self.paymentParticipationIds.map{$0.uuidString} as CKRecordValue
        
        
    }
    
}
