//
//  Cost.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 04/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//


import UIKit
import os.log
import CloudKit



//class Cost: Codable {
//
//    //MARK: Properties
//    var name: String
//    var amount: Double
//    var category: Category?
//    var payment: Payment
//    var date: Date
//    var currency: String
//    var concernedPeople: ConcernedPeople
//    var costId : String = UUID().uuidString
//    var tripId : String!
//    var buyerId : String!
//    var buyerShortName : String
//    //var spotEuro: Double
//
//    var payedBy: [String] = []
//    var payedFor: [String] = []
//    var type: CostType = CostType.Expenditure
//    var id = UUID()
//
//    struct CloudKey {
//        static let costId = "CostId"
//        static let name = "Name"
//        static let amount = "Amount"
//        static let category = "Category"
//        static let paymentType = "PaymentType"
//        static let date = "Date"
//        static let currency = "Currency"
//        static let concernedTravellers = "ConcernedTravellers"
//        static let buyerShortName = "BuyerShortName"
//        static let buyerId = "BuyerId"
//        static let tripId = "TripId"
//        static let trip = "Trip"
//        static let spotEuro = "SpotEuro"
//        static let payedBy = "payedBy"
//        static let payedFor = "payedFor"
//        static let type = "type"
//
//    }
//    //MARK: Initialization
//
//    init?(name: String,  amount: Double, category: Category?, payment: Payment, date: Date, buyer: Traveler, currency: String, concernedPeople: ConcernedPeople, spotEuro: Double) {
//
//        // Initialization should fail if there is no name.
//        guard !name.isEmpty else {
//            return nil
//        }
//
//        // Initialize stored properties.
//        self.name = name
//        self.amount = amount
//        self.category = category
//        self.payment = payment
//        self.date = date
//        self.currency = currency
//        self.concernedPeople = concernedPeople
//        self.buyerId = buyer.travellerId
//        self.buyerShortName = buyer.nickname
//        //self.spotEuro = spotEuro
//    }
//
//    init?(name: String, amount: Double, category: Category?, payment: Payment, date: Date, buyerId: String, buyerShortName: String, currency: String, concernedPeople: ConcernedPeople, costId: String, tripId: String, spotEuro: Double, payedBy: [String], payedFor: [String], type: CostType) {
//
//        // Initialization should fail if there is no name.
//        guard !name.isEmpty else {
//            return nil
//        }
//
//        // Initialize stored properties.
//        self.name = name
//        self.amount = amount
//        self.category = category
//        self.payment = payment
//        self.date = date
//        self.currency = currency
//        self.concernedPeople = concernedPeople
//        self.buyerId = buyerId
//        self.buyerShortName = buyerShortName
//        self.costId = costId
//        self.tripId = tripId
//        //self.spotEuro = spotEuro
//        self.payedBy = payedBy
//        self.payedFor = payedFor
//        self.type = type
//    }
//
//    func toRecord(tripRecordId: CKRecordID) -> CKRecord{
//        let record = CKRecord(recordType: "Cost", recordID: CKRecordID(recordName: costId, zoneID: CKRecordZone(zoneName: "CostTrackerCustomZone").zoneID))
//
//        record[CloudKey.name] = name as CKRecordValue
//        record[CloudKey.date] = date as CKRecordValue
//        record[CloudKey.amount] = amount as CKRecordValue
//        record[CloudKey.paymentType] = payment.int() as CKRecordValue
//        record[CloudKey.concernedTravellers] = concernedPeople.int() as CKRecordValue
//        record[CloudKey.costId] = costId as CKRecordValue
//        record[CloudKey.currency] = currency as CKRecordValue
//        record[CloudKey.buyerShortName] = buyerShortName as CKRecordValue
//        record[CloudKey.tripId] = tripId as CKRecordValue
//        record[CloudKey.buyerId] = buyerId as CKRecordValue
//        //record[CloudKey.spotEuro] = spotEuro as CKRecordValue
//
//        let tripReference = CKReference(recordID: tripRecordId, action: CKReferenceAction.deleteSelf)
//        record[CloudKey.trip] = tripReference as CKRecordValue
//
//        if let category = category {
//            record[CloudKey.category] = category.int() as CKRecordValue
//        }
//
//        return record
//    }
//}



