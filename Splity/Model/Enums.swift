//
//  Enums.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/07/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import Foundation


enum Category : Int, NSCodableEnum, Codable {
    case Food
    case Activity
    case Transport
    case Logement
    case Shopping
    case Unknown
    
    
    func toDescritpion() -> String {
        switch (self) {
        case .Food : return "Nourriture"
        case .Activity : return "Activité"
        case .Transport : return "Transport"
        case .Logement : return "Logement"
        case .Shopping : return "Shopping"
        case .Unknown : return "Inconnue"
        }
    }
    
    func int()->Int {
        return self.rawValue
    }
    init(defaultValue:Any) {
        self = .Unknown
    }
}

enum Payment : Int, NSCodableEnum , Codable{
    case Cash
    case Card
    
    func int()->Int {
        return self.rawValue
    }
    init(defaultValue:Any) {
        self = .Card
    }
    
    func toDescritpion() -> String {
        switch (self) {
        case .Card : return "Carte"
        case .Cash : return "Espèce"
        }
    }
}

enum CostType : Int, NSCodableEnum , Codable{
    case Expenditure
    case Refund
    case Withdrawal

    
    func int()->Int {
        return self.rawValue
    }
    init(defaultValue:Any) {
        self = .Expenditure
    }
    
    func toDescritpion() -> String {
        switch (self) {
        case .Expenditure : return "Dépense"
        case .Refund : return "Remboursement"
        case .Withdrawal : return "Retrait"
        }
    }
}


enum ConcernedPeople: Int, NSCodableEnum, Codable {
    case Single
    case Group
    
        
    func int()->Int {
        return self.rawValue
    }
    init(defaultValue:Any) {
        self = .Group
    }
}
