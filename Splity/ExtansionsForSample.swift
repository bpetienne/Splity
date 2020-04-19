//
//  TripTableViewControllerExtension.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 16/07/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//


import UIKit
import os.log


extension Model {

    
    func AddNewYorkTrip() {
        let photo1 = UIImagePNGRepresentation(UIImage(named: "meal1")!)
        
        let travellers = [Traveler("Benoit", nickname:"BE"), Traveler("Farida", nickname:"FR")]
        let costLoaderService = CostLoaderService()
        
        let costs = costLoaderService.importCosts()
        
        guard let trip1 = Trip(beginDate: Date(), endDate: Date(), currencies: ["EUR", "USD"], travellers: travellers, countries: ["New York"], imageData: photo1, mainCurrency: "USD", mainCountry: "New York", costs: costs, tripId: nil, travellerIds: [String](), note: "") else {
            fatalError("Unable to instantiate trip1")
        }
        
        
        trips += [trip1]
    }

    
    
    func loadSampleTrips() {
        let photo1 = UIImagePNGRepresentation(UIImage(named: "meal1")!)
        let photo2 = UIImagePNGRepresentation(UIImage(named: "meal2")!)
        let photo3 = UIImagePNGRepresentation(UIImage(named: "meal3")!)
        
        let travellers = [Traveler("Benoit", nickname:"BE"), Traveler("Farida", nickname:"FR")]
        
        guard let trip1 = Trip(beginDate: Date(), endDate: Date(), currencies: ["EUR", "USD"], travellers: travellers, countries: ["New York"], imageData: photo1, mainCurrency: "USD", mainCountry: "New York", costs: loadSampleCosts1(), tripId: nil, travellerIds: [String](), note: "") else {
            fatalError("Unable to instantiate trip1")
        }
        
        guard let trip2  = Trip(beginDate: Date(), endDate: Date(), currencies: ["EUR", "JPY"], travellers: travellers, countries: ["Tokyo"], imageData: photo2, mainCurrency: "JPY", mainCountry: "Tokyo", costs: loadSampleCosts2(), tripId: nil, travellerIds: [String](), note: "") else {
            fatalError("Unable to instantiate trip2")
        }
        
        guard let trip3 = Trip(beginDate: Date(), endDate: Date(), currencies: ["EUR", "EAD"], travellers: travellers, countries: ["Dubaï"], imageData: photo3, mainCurrency: "EAD", mainCountry: "Dubaï", costs: loadSampleCosts3(), tripId: nil, travellerIds: [String](), note: "") else {
            fatalError("Unable to instantiate trip3")
        }
        
        
        
        trips += [trip1, trip2, trip3]
    }
    
    
     func loadSampleCosts1() -> [Cost] {
        guard let cost1 = Cost(name: "Dépense 1 - Trip 1",  amount: 24.5, category: .Transport, payment: .Cash, date: Date(), buyer: Traveler("Benoit", nickname:"BE"), currency: "EUR", concernedPeople: .Group, spotEuro: 1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        
        let costs = [cost1]
        
        return costs
    }
    
    
     func loadSampleCosts2() -> [Cost] {
        guard let cost1 = Cost(name: "Dépense 1 - Trip 2", amount: 24.5, category: .Transport, payment: .Cash, date: Date(), buyer: Traveler("Benoit", nickname:"BE"), currency: "EUR", concernedPeople: .Group, spotEuro: 1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let cost2 = Cost(name: "Dépense 2 - Trip 2",  amount: 5.0, category: .Food, payment: .Cash, date: Date(), buyer: Traveler("Benoit", nickname:"BE"), currency: "EUR", concernedPeople: .Group, spotEuro: 1) else {
            fatalError("Unable to instantiate meal2")
        }
        
        let costs = [cost1, cost2]
        
        return costs
    }
    
    
     func loadSampleCosts3() -> [Cost] {
        guard let cost1 = Cost(name: "Dépense 1 - Trip 3", amount: 24.5, category: .Transport, payment: .Cash, date: Date(), buyer: Traveler("Benoit", nickname:"BE"), currency: "EUR", concernedPeople: .Group, spotEuro: 1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let cost2 = Cost(name: "Dépense 3 - Trip 3", amount: 5.0, category: .Food, payment: .Cash, date: Date(), buyer: Traveler("Benoit", nickname:"BE"), currency: "EUR", concernedPeople: .Group, spotEuro: 1) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let cost3 = Cost(name: "Dépense 3 - Trip 3",  amount: 15.0, category: .Activity, payment: .Card, date: Date(), buyer: Traveler("Benoit", nickname:"BE"), currency: "EUR", concernedPeople: .Single, spotEuro: 1) else {
            fatalError("Unable to instantiate meal2")
        }
        
        
        
        let costs = [cost1, cost2, cost3]
        
        return costs
    }
    

}

