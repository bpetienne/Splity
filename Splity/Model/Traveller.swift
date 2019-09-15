//
//  Traveller.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/07/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit


class Traveller:  Codable  {

    struct CloudKey {
        static let lastName = "LastName"
        static let firstName = "FirstName"
        static let email = "Email"
        static let photo = "Photo"
        static let phoneNumber = "PhoneNumber"
        static let travellerId = "TravellerId"
    }
    
    //MARK: Properties

    var firstName: String!
    var lastName: String!
    var email: String!
    var name: String!
    var nickname: String!
    var travellerId : String = UUID().uuidString
    var phoneNumber: String?

    init(_ name:String, nickname:String) {
        self.name = name
        self.nickname = nickname
        
    }
    
    init(firstName:String, lastName:String, email:String,travellerId: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        
        self.nickname = ""
        self.name = ""

        self.travellerId = travellerId

        self.getShortName()
        self.getName()
    }
    
    func getFirstLetter(_ inputString:String) -> String{
        if inputString == "" {
            return ""
        }
        let letter = String(inputString[..<inputString.index(inputString.startIndex, offsetBy: 1)])
        return letter
    }
    
    func getShortName()
    {
        if self.firstName == "" && self.lastName == "" {
            self.nickname = "??"
        }
        
        else {
            self.nickname = getFirstLetter(self.firstName) + getFirstLetter(self.lastName)
        }
    }
    
    func getName()
    {
        if self.firstName == "" && self.lastName == "" {
            self.name = "????"
        }
        else if self.firstName == ""{
            self.name = self.lastName
        }
        else if self.lastName == ""{
            self.name = self.firstName
        }
        else {
            self.name = self.firstName + " " + self.lastName
        }
 
    }
    
    func toRecord() -> CKRecord
    {
        let record = CKRecord(recordType: "Traveller", recordID: CKRecordID(recordName: travellerId, zoneID: CKRecordZone(zoneName: "CostTrackerCustomZone").zoneID))

        if let email = email{
            record[CloudKey.email] = email as CKRecordValue
        }
        
        if let lastName = lastName{
            record[CloudKey.lastName] = lastName as CKRecordValue
        }
        
        if let firstName = firstName{
            record[CloudKey.firstName] = firstName as CKRecordValue
        }
        
        if let phoneNumber = phoneNumber{
            record[CloudKey.phoneNumber] = phoneNumber as CKRecordValue
        }
        record[CloudKey.travellerId] = travellerId as CKRecordValue

        return record
    }
    
    
  
}

