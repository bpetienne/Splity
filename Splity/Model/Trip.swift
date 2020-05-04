//
//  Trip.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit

//class Trip:  Codable {
//    
//
//    //MARK: Properties
//    var name: String!
//    var beginDate: Date
//    var endDate: Date
//    var mainCurrency: String?
//    var currencies: [String]
//    var mainCountry: String?
//    var countries: [String]
//    var costs: [Cost]
//    var note: String!
//    var isModified = false
//    var tripId : String = UUID().uuidString
//    var imageData: Data?
//    var travellers: [String:Traveler] = [String:Traveler]()
//
//    var modelDelegate: ModelDelegate? = nil
//
//    var photo: UIImage? {
//        if let data = self.imageData,  let image =  UIImage(data: data){
//            return image
//        }
//        return nil
//    }
//    
//    private let costComputationService = CostComputationService()
//
//    var total: Double { return costComputationService.total }
//    var nilCategory: Double { return costComputationService.nilCategory }
//    var costByCategories: [Category:Double] { return costComputationService.costByCategories }
//    var costByDate: [Date:Double] { return costComputationService.costByDate }
//    var costByPayment: [Payment:Double] { return costComputationService.costByPayment }
//    var costByPeople: [String:Double] { return costComputationService.costByPeople }
//    var totalPerDayPerPerson : Double { return costComputationService.totalPerDayPerPerson }
//    var totalPerDay : Double { return costComputationService.totalPerDay }
//    var totalPerPerson : Double { return costComputationService.totalPerPerson }
//    var numberOfDays : Int { return endDate.interval(ofComponent: .day, fromDate: beginDate) }
//    var numberOfPeople: Int {return travellers.count}
//    var randomFont = Helper.randomFont()
//    
//    static let MaxPhotoWidth: CGFloat = 800
//    
//
////    func encode(to encoder: Encoder) throws {
////        var container = encoder.container(keyedBy: EncodingKeys.self)
////        try container.encode(name, forKey: .name)
////        try container.encode(beginDate, forKey: .beginDate)
////        try container.encode(endDate, forKey: .endDate)
////        // ...
////    }
//    
////    init(from decoder: Decoder) throws {
////        let values = try decoder.container(keyedBy: DecodingKeys.self)
////        name = try values.decode(String.self, forKey: .name)
////        beginDate = try values.decode(Date.self, forKey: .beginDate)
////        endDate = try values.decode(Date.self, forKey: .endDate)
////        // ...
////    }
//    
//    init?(beginDate: Date, endDate:Date, currencies: [String], travellers: [Traveler], countries: [String], imageData: Data?, mainCurrency: String?, mainCountry: String?, costs: [Cost], tripId: String?, travellerIds: [String], note: String?) {
//
//        self.beginDate = beginDate
//        self.endDate = endDate
//        self.currencies = currencies
//        self.countries = countries
//        self.mainCountry = mainCountry
//        self.mainCurrency = mainCurrency
//        self.costs = costs
//        if let tripId = tripId {
//            self.tripId = tripId
//        }
//        self.note = note
//        self.imageData  = imageData
//        self.travellers = [String:Traveler]()
//    
//        recomputeCosts()
//    }
//    
//     init() {
//        self.beginDate = Date(timeIntervalSinceNow: 0)
//        self.endDate = Date(timeIntervalSinceNow: 0)
//        self.currencies = [String]()
//        self.countries = [String]()
//        self.mainCountry = countries.first
//        self.mainCurrency = currencies.first
//        self.costs = [Cost]()
//        self.note = ""
//        self.imageData = nil
//        self.travellers = [String:Traveler]()
//
//        recomputeCosts()
//    }
//    
//    init(in model: Model) {
//        self.beginDate = Date(timeIntervalSinceNow: 0)
//        self.endDate = Date(timeIntervalSinceNow: 0)
//        self.currencies = [String]()
//        self.countries = [String]()
//        self.mainCountry = countries.first
//        self.mainCurrency = currencies.first
//        self.costs = [Cost]()
//        self.note = ""
//        self.imageData = nil
//        self.travellers = [String:Traveler]()
//        modelDelegate = model
//        
//        recomputeCosts()
//    }
//    
//    
//
//    
//    func getBuyerName(currentBuyerId: String?) -> String{
//        if let currentBuyerId = currentBuyerId, let traveller = modelDelegate?.allTravellers[currentBuyerId]{
//            return traveller.firstName
//        }
//        return "?"
//    }
//    
//    func selectNextTraveler(currentBuyerId: String?) -> (id:String, name:String, shortName: String) {
//        if let currentBuyerId = currentBuyerId{
//            if travellers.keys.contains(currentBuyerId){
//                var isFound = false
//                for travellerId in travellers.keys {
//                    if let traveller = modelDelegate?.allTravellers[travellerId]{
//                        if isFound == true {
//                            return (traveller.travellerId, traveller.firstName!, traveller.nickname)
//                        }
//                        if traveller.travellerId == currentBuyerId {
//                            isFound = true
//                        }
//                    }
//                }
//            }
//        }
//        
//        if let travellerId = travellers.keys.first {
//            if let traveller = modelDelegate?.allTravellers[travellerId]{
//                return (traveller.travellerId, traveller.firstName, traveller.nickname)
//            }
//        }
//        return ("?","?", "?")
//    }
//    
//    func selectNextCurrency(currentCurrency: String?) -> String {
//        if let currentCurrency = currentCurrency{
//            if currencies.contains(currentCurrency){
//                var isFound = false
//                for currency in currencies {
//                    if isFound == true {
//                        return currency
//                    }
//                    if currency == currentCurrency {
//                        isFound = true
//                    }
//                }
//            }
//        }
//        
//        if let currency = currencies.first {
//            return currency
//        }
//        return "?"
//    }
//    
//    func updateCosts( costs: [Cost]) {
//        self.costs = costs
//        isModified = true
//        modelDelegate?.tripDidFinish( trip: self)
//        recomputeCosts()
//    }
//    
//    func saveImageInData(){
//        if let image = self.photo {
//            self.imageData  = UIImagePNGRepresentation(image)
//        }
//    }
//
// 
//    
//    
//    
//    
//    func tryRemoveTraveller(travellerId: String) {
//         modelDelegate?.tryRemoveTraveller(travellerId: travellerId)
//    }
//    
//    func travellerIsUsed(travellerId: String) -> Bool{
//        if let travellerProvider = modelDelegate {
//            return travellerProvider.travellerIsUsed(travellerId: travellerId)
//        }
//        return false
//    }
//    
//    func add(traveller: Traveler) {
//        modelDelegate?.save(traveller: traveller)
//    }
//    
//    func getTraveller(id: String) -> Traveler? {
//        return modelDelegate?.getTraveller(id: id)
//    }
//    
//    //MARK: export URL
//        static func importData(from url: URL) -> Trip? {
//            
//            let trip = createTrip(from: url)
//            
//            do {
//                try FileManager.default.removeItem(at: url)
//            } catch {
//                print("Failed to remove item from Inbox")
//            }
//            return trip
//        }
//        
//        static func createTrip(from url: URL) -> Trip?{
//            if let json = try? Data(contentsOf: url), let trip = Trip.jsonToTrip(jsonData: json) {
//                return trip
//            }
//            
//            return nil
//        }
//        
//        func exportToFileURL() -> URL? {
//            
//            let json = tripToJson()
//            
//            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//                return nil
//            }
//            
//            let saveFileURL = path.appendingPathComponent("\(mainCountry ?? "untitled").ctkr")
//            if let json = json {
//                try? json.write(to: saveFileURL)
//            }
//            return saveFileURL
//        }
//        
//        func addImportedCosts(costs newCosts: [Cost]){
//            for cost in newCosts{
//                if (!costs.contains {$0.costId == cost.costId}) {
//                    costs.append(cost)
//                }
//            }
//            recomputeCosts()
//        }
//    
//    //MARK: update Trip
//    
//    
//    func saveText(noteText: String?){
//        self.note = noteText
//        tripDidFinish( trip: self)
//    }
//    
//    func tripDidFinish(trip: Trip) {
//        trip.isModified = true
//        trip.recomputeCosts()
//        
//        modelDelegate?.tripDidFinish(trip: trip)
//        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: Configuration.updateTripNotificationKey), object: trip.tripId)
//    }
//    
//    func update(travellerIds: [String]){
//        self.travellers.removeAll()
//        for travellerId in travellerIds{
//            if let traveller = modelDelegate?.getTraveller(id: travellerId){
//                travellers[travellerId] = traveller
//            }
//        }
//        tripDidFinish(trip: self)
//    }
//    
//    func update(beginDate date: Date?){
//        if let date = date {
//            self.beginDate = date
//        }
//        tripDidFinish( trip: self)
//    }
//    
//    func update(endDate date: Date?){
//        if let date = date {
//            self.endDate = date
//        }
//        tripDidFinish( trip: self)
//    }
//    
//    func add(currency: String){
//        self.currencies.append(currency)
//        self.mainCurrency = currencies.first
//        tripDidFinish( trip: self)
//    }
//    
//    func remove(currencyAt: Int){
//        self.currencies.remove(at: currencyAt)
//        self.mainCurrency = currencies.first
//        tripDidFinish( trip: self)
//    }
//    
//    func add(destination: String) {
//        self.countries.append(destination)
//        self.mainCountry = countries.first
//        tripDidFinish( trip: self)
//    }
//    
//    func remove(destinationAt: Int){
//        self.countries.remove(at: destinationAt)
//        self.mainCountry = countries.first
//        tripDidFinish( trip: self)
//    }
//    
//    func add(image: UIImage?) {
//        if let image = image {
//            if image.size.width > Trip.MaxPhotoWidth {
//                if let image = image.resize(toWidth: Trip.MaxPhotoWidth){
//                    self.imageData = UIImagePNGRepresentation(image)
//                }
//            }
//            else {
//                self.imageData = UIImagePNGRepresentation(image)
//            }
//        }
//        tripDidFinish(trip: self)
//    }
//    
//    func recomputeCosts() {
//        let num = numberOfDays
//        costComputationService.computeCostByCategories(costs: costs, numberOfDays: num, numberOfPeople: numberOfPeople )
//    }
//    
//    func initialize(model: Model) {
//        modelDelegate = model
//    }
//    
//    
//    
//    static func loadCoverPhoto(_ recordValue: CKRecordValue?) -> UIImage? {
//        
//        var image: UIImage!
//        
//        guard let asset = recordValue as? CKAsset else {
//            return nil
//        }
//        
//        let imageData: Data
//        do {
//            imageData = try Data(contentsOf: asset.fileURL)
//        } catch {
//            return nil
//        }
//        image = UIImage(data: imageData)
//        return image
//    }
//    
//   
//}
