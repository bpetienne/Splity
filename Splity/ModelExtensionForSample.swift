//
//  ModelExtensionForSample.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 16/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation

extension Model{
    
    func loadSampleTrip(){
        
        if trips.count ==  0 {
            loadSampleTrips()
            for trip in trips {
                tripsUUID.append(trip.tripId)
            }
        }
    }
    
    func createTravellerAgain(){
        let sham = travellers.first!
        travellers.removeAll()
        let trav1 = travellers[trips.first!.travellers.keys.first!]
        //let trav2 = travellers[trips.first!.travellers.keys.!]
        save(traveller: trav1!)
        //save(traveller: trav2!)
        save(traveller: sham.value)
        
        
    }
    
    func modifyTravellers(){
        for trip in trips{
            //            for traveller in trip.travellerIds{
            //                if let trav = travellersByNickname[traveller.nickname]{
            //                    traveller.name = trav.name
            //                    traveller.email = trav.email
            //                    traveller.firstName = trav.firstName
            //                    traveller.lastName = trav.lastName
            //                    traveller.nickname = trav.nickname
            //                    traveller.travellerId = trav.travellerId
            //                }
            //            }
            trip.travellers = travellers
            
            for cost in trip.costs{
                if let trav = travellersByNickname[cost.buyerShortName]{
                    cost.buyerShortName = trav.nickname
                    cost.buyerId = trav.travellerId
                    cost.tripId = trip.tripId
                    
                }
                
            }
            
            //save(trip: trip)
        }
    }
    
    
    
    func createDefautlTravellers(){
        let benoit = Traveler(firstName: "Benoit", lastName: "Etienne", email: "bp.etienne@gmail.com", travellerId: UUID().uuidString)
        let farida = Traveler(firstName: "Farida", lastName: "Radjabaly", email: "fradjabaly@gmail.com", travellerId: UUID().uuidString)
        
        travellers[benoit.travellerId] = benoit
        travellers[farida.travellerId] = farida
        
        travellersByNickname[benoit.nickname] = benoit
        travellersByNickname[farida.nickname] = farida
        
        for trav in travellers{
            save(traveller: trav.value)
        }
        
        
    }
}
