//
//  TripDataModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 14/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit

class TripDataModel:  BaseDataModel {
    
    //MARK: Properties
    var name: String?
    var beginDate: Date?
    var endDate: Date?
    var lastCurrencyCode: String?
    var currencyCodes: [String] = [String]()
    var mainCountry: String?
    var countries: [String] = [String]()
    var imageData: Data?
    var costIds: [UUID] = [UUID]()
    var travelerIds: [UUID] = [UUID]()
    
    override init(id: UUID)
    {
        super.init(id: id)
    }
    
    //MARK: Local Repository
    private enum CodingKeys: String, CodingKey {
        case name
        case beginDate
        case endDate
        case lastCurrencyCode
        case currencyCodes
        case mainCountry
        case countries
        case imageData
        case costIds
        case travelerIds
    }
    
    override func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(name, forKey: .name)
          try container.encode(beginDate, forKey: .beginDate)
          try container.encode(endDate, forKey: .endDate)
          try container.encode(lastCurrencyCode, forKey: .lastCurrencyCode)
          try container.encode(currencyCodes, forKey: .currencyCodes)
          try container.encode(mainCountry, forKey: .mainCountry)
          try container.encode(countries, forKey: .countries)
          try container.encode(imageData, forKey: .imageData)
          try container.encode(costIds, forKey: .costIds)
          try container.encode(travelerIds, forKey: .travelerIds)

        try super.encode(to: encoder)
      }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.beginDate = try container.decode(Date.self, forKey: .beginDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
        self.lastCurrencyCode = try container.decode(String.self, forKey: .lastCurrencyCode)
        self.currencyCodes = try container.decode([String].self, forKey: .currencyCodes)
        self.mainCountry = try container.decode(String.self, forKey: .mainCountry)
        self.countries = try container.decode([String].self, forKey: .countries)
        self.imageData = try container.decode(Data.self, forKey: .imageData)
        self.costIds = try container.decode([UUID].self, forKey: .costIds)
        self.travelerIds = try container.decode([UUID].self, forKey: .travelerIds)
        try super.init(from: decoder)
    }
    
    
    //MARK: Remote Repository
    enum RemoteKey: String {
           case name
           case beginDate
           case endDate
           case lastCurrencyCode
           case currencyCodes
           case mainCountry
           case countries
           case imageData
           case costIds
           case travelerIds
       }
       
    
    override func createRecord() -> CKRecord
    {
        return CKRecord(recordType: CloudKitName.tripRecordType, recordID: CKRecordID(recordName: recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    override func fromRecord(record: CKRecord)
    {
        super.fromRecord(record: record)
        
        if let data = record[RemoteKey.name] as? String {
            self.name = data
        }
        
        if let data = record[RemoteKey.beginDate] as? Date {
            self.beginDate = data
        }
        
        if let data = record[RemoteKey.endDate] as? Date {
            self.endDate = data
        }
        
        if let data = record[RemoteKey.lastCurrencyCode] as? String? {
            self.lastCurrencyCode = data
        }
        
        if let data = record[RemoteKey.mainCountry] as? String {
            self.mainCountry = data
        }
        
        if let data = record[RemoteKey.countries] as? [String] {
            self.countries = data
        }
        
        if let data = record[RemoteKey.currencyCodes] as? [String] {
            self.currencyCodes = data
        }
        
        if let data = record[RemoteKey.imageData] as? Data {
            self.imageData = data
        }
        
        if let data = record[RemoteKey.costIds] as? [String] {
            self.costIds = data.map{UUID(uuidString: $0)!}
        }
        
        if let data = record[RemoteKey.travelerIds] as? [String] {
            self.travelerIds = data.map{UUID(uuidString: $0)!}
        }
    }
    
    override func fillRecord(record: CKRecord)
    {
        super.fillRecord(record: record)
        
        if let name = name {
            record[RemoteKey.name] = name as CKRecordValue
        }
        
        if let lastCurrencyCode = lastCurrencyCode {
            record[RemoteKey.lastCurrencyCode] = lastCurrencyCode as CKRecordValue
        }
        if let mainCountry = mainCountry {
            record[RemoteKey.mainCountry] = mainCountry as CKRecordValue
        }
        
        if let beginDate = beginDate {
            record[RemoteKey.beginDate] = beginDate as CKRecordValue
        }
        
        if let endDate = endDate {
            record[RemoteKey.endDate] = endDate as CKRecordValue
        }
        
        
        record[RemoteKey.countries] = countries as CKRecordValue
        record[RemoteKey.currencyCodes] = currencyCodes as CKRecordValue
        record[RemoteKey.costIds] = costIds.map{$0.uuidString} as CKRecordValue
        record[RemoteKey.travelerIds] = travelerIds.map{$0.uuidString} as CKRecordValue
        
        //todo
        //image
        //record[RemoteKey.imageData] = imageData as CKRecordValue
        
        //        if let photo = photo {
        //            do {
        //                let url = Trip.getTempCoverPhotoURL(tripId)
        //                let data = UIImagePNGRepresentation(photo)!
        //                try data.write(to: url, options: Data.WritingOptions.atomicWrite)
        //                let asset = CKAsset(fileURL: url)
        //                record[RemoteKey.coverPhoto] = asset
        //            }
        //            catch {
        //                print("Error writing data", error)
        //            }
        //        }
        
    }
}


