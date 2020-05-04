//
//  Extensions.swift
//  Splity
//
//  Created by Benoit ETIENNE on 19/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import Foundation
import CloudKit



extension CKRecord {
    
    subscript(key: BaseDataModel.BaseRemoteKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
    subscript(key: CostDataModel.RemoteKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
    subscript(key: TripDataModel.RemoteKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
    subscript(key: TravelerDataModel.RemoteKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
    subscript(key: PaymentParticipationDataModel.RemoteKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
    subscript(key: ApplicationDataModel.RemoteKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
    
}
