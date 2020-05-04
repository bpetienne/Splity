//
//  BaseModel.swift
//  Splity
//
//  Created by Benoit ETIENNE on 18/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import Foundation
import CloudKit

class BaseDataModel: LocalProtocol, CloudProtocol {
    
    var id : UUID
    var recordName: String { get {return  id.uuidString}}
    
    var localCreationDate: Date?
    var lastLocalModificationDate: Date?
    
    var lastRemoteSaveDate: Date?
    var lastLocalSaveDate: Date?
    var lastLocalLoadDate:Date?
    var lastRemoteLoadDate:Date?
    
    var remoteModificationDate: Date?
    var remoteCreationDate: Date?
    
    
    init(id: UUID)
    {
        self.localCreationDate = Date.init(timeIntervalSinceNow: 0)
        self.id = id
    }
    

    
    //MARK: Local Repository

   var archivedUrl: URL? {
    return type(of: self).getArchivedUrl(self.id, "\(type(of: self))") }
      
    static func getArchivedUrl(_ uuid: UUID?, _ type: String) -> URL? {
        if let uuid = uuid {
            return Configuration.DocumentsDirectory.appendingPathComponent("\(type)_\(uuid.uuidString).splity")
        }
        return nil
    }
    
    func load<T: LocalProtocol>(_ uuid: UUID? = nil) -> T?{
        guard let url = T.getArchivedUrl(uuid, "\(type(of: self))") else {
            return nil }

        guard let data = try? Data(contentsOf: url) else {
            return nil }

        guard let decoded:T = fromData(data) else {
            return nil}
        return decoded
    }

    func fromData<T: LocalProtocol>(_ data: Data?) -> T?{
        if let data = data {
            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                return nil}
            return decoded
        }
        return nil
    }
    
    
//    func save<T: LocalProtocol>(_ codable: T) -> Bool {
//        guard let url = codable.archivedUrl else {
//            return false}
//        guard let data = toData(codable) else {
//            return false}
//        return (try? data.write(to: url)) != nil
//    }
//
//    func toData<T: LocalProtocol>(_ codable: T) -> Data?{
//           if let data = try? JSONEncoder().encode(self){
//               return data
//           }
//           return nil
//       }
//
    
//    func load(_ uuid: UUID? = nil) -> BaseDataModel?{
//           guard let url = Self.getArchivedUrl(uuid, "\(type(of: self))") else {
//               return nil }
//           
//           guard let data = try? Data(contentsOf: url) else {
//               return nil }
//           
//           guard let decoded = fromData(data) else {
//               return nil}
//           return decoded
//       }
//       
//       func fromData(_ data: Data?) -> BaseDataModel?{
//           if let data = data {
//            guard let decoded = try? JSONDecoder().decode(BaseDataModel.self, from: data) else {
//                   return nil}
//               return decoded
//           }
//           return nil
//       }
    
    func save() -> Bool {
        guard let url = self.archivedUrl else {
            return false}
        guard let data = toData() else {
            return false}
        return (try? data.write(to: url)) != nil
    }
    
    func toData() -> Data?{
        if let data = try? JSONEncoder().encode(self){
            return data
        }
        return nil
    }
    
    
    
    //MARK: Cloud Repository
    
    enum BaseRemoteKey: String {
        case id
        case localCreationDate
        case lastLocalModificationDate
        case lastRemoteSaveDate
        case lastLocalSaveDate
        case lastRemoteLoadDate
        case lastLocalLoadDate
        case remoteModificationDate
        case remoteCreationDate
    }
    
    func toRecord() -> CKRecord
    {
        let record = createRecord()
        fillRecord(record: record)
        return record
    }
    
    internal func createRecord() -> CKRecord
    {
       CKRecord(recordType: CloudKitName.baseModelRecordType, recordID: CKRecordID(recordName: self.recordName, zoneID: CKRecordZone(zoneName: CloudKitName.costTrackerCustomZone).zoneID))
    }
    
    func fromRecord(record: CKRecord)
    {
        if let data = record[BaseRemoteKey.id] as? String {
            if let uuid = UUID(uuidString: data){
                self.id = uuid
            }
        }
        
        if let data = record[BaseRemoteKey.localCreationDate] as? Date {
            self.localCreationDate = data
        } else{
              self.localCreationDate = nil
        }
        
        if let data = record[BaseRemoteKey.lastLocalModificationDate] as? Date {
            self.lastLocalModificationDate = data
        }
        
        if let data = record[BaseRemoteKey.lastLocalSaveDate] as? Date {
            self.lastLocalSaveDate = data
        }
        
        if let data = record[BaseRemoteKey.lastLocalLoadDate] as? Date {
            self.lastLocalLoadDate = data
        }
        if let data = record[BaseRemoteKey.lastRemoteSaveDate] as? Date {
            self.lastRemoteSaveDate = data
        }
        
        if let data = record[BaseRemoteKey.lastRemoteLoadDate] as? Date {
            self.lastRemoteLoadDate = data
        }
        
        if let data = record[BaseRemoteKey.remoteModificationDate] as? Date {
            self.remoteModificationDate = data
        }
        
        if let data = record[BaseRemoteKey.remoteCreationDate] as? Date {
            self.remoteCreationDate = data
        }
    }
    
    func fillRecord(record: CKRecord)
    {
        if let data = self.localCreationDate {
            record[BaseRemoteKey.localCreationDate] = data as CKRecordValue
        }
        if let data = self.lastLocalModificationDate {
            record[BaseRemoteKey.lastLocalModificationDate] = data as CKRecordValue
        }
        if let data = self.lastRemoteSaveDate {
            record[BaseRemoteKey.lastRemoteSaveDate] = data as CKRecordValue
        }
        if let data = self.lastLocalSaveDate {
            record[BaseRemoteKey.lastLocalSaveDate] = data as CKRecordValue
        }
        if let data = self.lastRemoteLoadDate {
            record[BaseRemoteKey.lastRemoteLoadDate] = data as CKRecordValue
        }
        if let data = self.lastLocalLoadDate {
            record[BaseRemoteKey.lastLocalLoadDate] = data as CKRecordValue
        }
        if let data = self.remoteModificationDate {
            record[BaseRemoteKey.remoteModificationDate] = data as CKRecordValue
        }
        if let data = self.remoteCreationDate {
            record[BaseRemoteKey.remoteCreationDate] = data as CKRecordValue
        }
        
        record[BaseRemoteKey.id] = self.id.uuidString as CKRecordValue
    }
}
