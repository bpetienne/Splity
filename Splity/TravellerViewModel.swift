//
//  TravellerViewModel.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation

class TravellerViewModel
{
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var travellerId: String = UUID().uuidString
    
    init(){
        
    }
    
    init(traveller: Traveller){
        firstName = traveller.firstName
        lastName = traveller.lastName
        email = traveller.email
        phoneNumber = traveller.phoneNumber
        travellerId = traveller.travellerId
    }
}
