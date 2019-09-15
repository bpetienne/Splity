//
//  CostLoaderService.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 29/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit



//Pour charger les dépenses du voyage à New York à partir d'une extraction de la Google Sheets
class CostLoaderService {
    
    let Transport = UIImage(named: "transport")
    let Shopping = UIImage(named: "shopping")
    let Nourriture = UIImage(named: "food")
    let Logement = UIImage(named: "logement")
    let Activity = UIImage(named: "activity")
    let Visite = UIImage(named: "activity")
    let Course = UIImage(named: "shopping")
    let Divers = UIImage(named: "activity")
    
    func importCosts() -> [Cost] {
        
        var costs = [Cost]()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy"
        let usd = 0.83

        
        costs += [Cost(name: "Billet d'avion",  amount: 974.16, category: .Transport, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast",  amount: 42954, category: .Food, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Uber",  amount: 40, category: .Transport, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Hotel",  amount: 718.6, category: .Logement, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Train aéroport",  amount: 42869, category: .Transport, payment: .Cash, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Air Train",  amount: 11, category: .Transport, payment: .Cash, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Shack Shake",  amount: 36.01, category: .Food, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Rum House",  amount: 33.75, category: .Food, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Gotan",  amount: 33, category: .Food, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "T-Shirt NBA",  amount: 61.98, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 6, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Produit Clinic",  amount: 83.29, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Sac Michael Kors",  amount: 105, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Starbucks",  amount: 2.45, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Victoria Secret",  amount: 52.5, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Starbucks",  amount: 9.15, category: .Food, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bath & Body Works",  amount: 85.47, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Century 21",  amount: 617.22, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Burger King",  amount: 19.25, category: .Food, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - retour",  amount: 25, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "match NBA",  amount: 338.4, category: .Activity, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - match NBA",  amount: 15, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Popcorn",  amount: 6.25, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Boisson",  amount: 12, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Sushi",  amount: 5.28, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Hot dog",  amount: 9, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bar",  amount: 6, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 42860, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 42860, category: .Transport, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Restaurant Shanghai ",  amount: 45.95, category: .Food, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Patch dos",  amount: 6.95, category: .Shopping, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bracelet",  amount: 42956, category: .Shopping, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Donuts ",  amount: 4.55, category: .Food, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 10, category: .Transport, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "McDo ",  amount: 42755, category: .Food, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Pain quotidien",  amount: 39.09, category: .Food, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Tips",  amount: 5, category: .Food, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 12, category: .Transport, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bouchon oreille",  amount: 42923, category: .Shopping, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Red Flame Diner",  amount: 40.5, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 12, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Musée Guggenheim",  amount: 50, category: .Activity, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Manucure",  amount: 37, category: .Activity, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bagel",  amount: 30.42, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Homeless",  amount: 1, category: .Activity, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 10, category: .Transport, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Starbucks",  amount: 23.25, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - soirée Barclays",  amount: 21, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Cocktail - bar 1",  amount: 18, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Cocktail - le bain",  amount: 21, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - entre les deux bars",  amount: 8, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Cocktail PHD *2",  amount: 42, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Toilette",  amount: 1, category: .Activity, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - retour",  amount: 11, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Gotan",  amount: 35.91, category: .Food, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Lottery",  amount: 2, category: .Shopping, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Century 21",  amount: 47.19, category: .Shopping, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 13, category: .Transport, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "MMS",  amount: 65.27, category: .Shopping, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Magnolia Bakery",  amount: 13.25, category: .Food, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Top of the Rock",  amount: 68, category: .Activity, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 13, category: .Transport, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Eau",  amount: 3.26, category: .Food, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Snack aéroport",  amount: 16.74, category: .Food, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Snack aéroport",  amount: 42771, category: .Food, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Uber Paris",  amount: 29, category: .Transport, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Lottery",  amount: 2, category: .Shopping, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]

        return costs
    }
    
    
    func importCosts2() -> [Cost] {
        
        var costs = [Cost]()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy"
        let usd = 0.83
        
        costs += [Cost(name: "Billet d'avion",  amount: 974.16, category: .Transport, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast",  amount: 7.8, category: .Food, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Uber",  amount: 40, category: .Transport, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Hotel",  amount: 718.6, category: .Logement, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Train aéroport",  amount: 14.5, category: .Transport, payment: .Cash, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Air Train",  amount: 11, category: .Transport, payment: .Cash, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Shack Shake",  amount: 36.01, category: .Food, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Rum House",  amount: 33.75, category: .Food, payment: .Card, date: formatter.date(from: "24/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Gotan",  amount: 33, category: .Food, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "T-Shirt NBA",  amount: 61.98, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 6, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Produit Clinic",  amount: 83.29, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Sac Michael Kors",  amount: 105, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Starbucks",  amount: 2.45, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Victoria Secret",  amount: 52.5, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Starbucks",  amount: 9.15, category: .Food, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bath & Body Works",  amount: 85.47, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Century 21",  amount: 617.22, category: .Shopping, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Burger King",  amount: 19.25, category: .Food, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - retour",  amount: 25, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "match NBA",  amount: 338.4, category: .Activity, payment: .Card, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - match NBA",  amount: 15, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Popcorn",  amount: 6.25, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Boisson",  amount: 12, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Sushi",  amount: 5.28, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Hot dog",  amount: 9, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bar",  amount: 6, category: .Food, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 5.5, category: .Transport, payment: .Cash, date: formatter.date(from: "25/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 5.5, category: .Transport, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Restaurant Shanghai ",  amount: 45.95, category: .Food, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Patch dos",  amount: 6.95, category: .Shopping, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bracelet",  amount: 9.8, category: .Shopping, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Donuts ",  amount: 4.55, category: .Food, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 10, category: .Transport, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "McDo ",  amount: 20.1, category: .Food, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Pain quotidien",  amount: 39.09, category: .Food, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Tips",  amount: 5, category: .Food, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 12, category: .Transport, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bouchon oreille",  amount: 7.07, category: .Shopping, payment: .Card, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Red Flame Diner",  amount: 40.5, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 12, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Musée Guggenheim",  amount: 50, category: .Activity, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Manucure",  amount: 37, category: .Activity, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Bagel",  amount: 30.42, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Homeless",  amount: 1, category: .Activity, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 10, category: .Transport, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Starbucks",  amount: 23.25, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - soirée Barclays",  amount: 21, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Cocktail - bar 1",  amount: 18, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Cocktail - le bain",  amount: 21, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - entre les deux bars",  amount: 8, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Cocktail PHD *2",  amount: 42, category: .Food, payment: .Card, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Toilette",  amount: 1, category: .Logement, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi - retour",  amount: 11, category: .Transport, payment: .Cash, date: formatter.date(from: "27/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Breakfast - Gotan",  amount: 35.91, category: .Food, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Lottery",  amount: 2, category: .Shopping, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Century 21",  amount: 47.19, category: .Shopping, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Taxi",  amount: 13, category: .Transport, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "MMS",  amount: 65.27, category: .Shopping, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Magnolia Bakery",  amount: 13.25, category: .Food, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Top of the Rock",  amount: 68, category: .Activity, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Metro",  amount: 13, category: .Transport, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Eau",  amount: 3.26, category: .Food, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Snack aéroport",  amount: 16.74, category: .Food, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Snack aéroport",  amount: 5.2, category: .Food, payment: .Cash, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Uber Paris",  amount: 29, category: .Transport, payment: .Card, date: formatter.date(from: "28/2/2017")!, buyer: Traveller("BE", nickname: "BE"), currency: "EUR", concernedPeople: .Group, spotEuro: usd)!]
        costs += [Cost(name: "Lottery",  amount: 2, category: .Shopping, payment: .Cash, date: formatter.date(from: "26/2/2017")!, buyer: Traveller("FR", nickname: "FR"), currency: "USD", concernedPeople: .Group, spotEuro: usd)!]
        
        return costs
    }
}
