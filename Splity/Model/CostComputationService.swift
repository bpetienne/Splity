//
//  CostComputationService.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 28/07/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import Foundation

class CostComputationService {
    
    var costByCategories = [Category:Double]()
    var costByPeople = [String:Double]()
    var costByDate = [Date:Double]()
    var costByPayment = [Payment:Double]()
    var nilCategory : Double = 0
    var total : Double = 0
    var totalPerDayPerPerson : Double = 0
    var totalPerDay : Double = 0
    var totalPerPerson : Double = 0
    var numberOfDays : Int = 0
    var numberOfPeople : Int = 0


    func computeCostByCategories(costs:[Cost],numberOfDays: Int, numberOfPeople: Int )
    {
        self.numberOfDays = numberOfDays
        self.numberOfPeople = numberOfPeople
        costByCategories = [Category:Double]()
        costByPeople = [String:Double]()
        costByDate = [Date:Double]()
        costByPayment = [Payment:Double]()
        nilCategory = 0
        total  = 0
        
        for cost in costs {
            
            let fxRate = Configuration.Currencies[cost.currency] ?? 1
            let costAmountInEuro = cost.amount * fxRate
            
            if let category = cost.category {
                if !costByCategories.keys.contains(category) {
                    costByCategories[category] = 0
                }
                costByCategories[category]! +=  costAmountInEuro
                
            }
            else {
                nilCategory += costAmountInEuro
            }
            
            if !costByPeople.keys.contains(cost.buyerId) {
                costByPeople[cost.buyerId] = 0
            }
            costByPeople[cost.buyerId]! +=  costAmountInEuro

            
            if !costByPayment.keys.contains(cost.payment) {
                costByPayment[cost.payment] = 0
            }
            costByPayment[cost.payment]! +=  costAmountInEuro

            //let date = cost.date
            let cal = Calendar(identifier: .gregorian)
            
           let components = cal.dateComponents([.day , .month, .year ], from: cost.date)
            if let newDate = cal.date(from: components)
            {
                if !costByDate.keys.contains(newDate) {
                    costByDate[newDate] = 0
                }
                costByDate[newDate]! +=  costAmountInEuro
            }
         total += costAmountInEuro
        }
        
        totalPerDay = total / Double(numberOfDays)
        totalPerPerson = total / Double(numberOfPeople)
        totalPerDayPerPerson = total / Double(numberOfPeople) / Double(numberOfDays)

//        costByDate = costByDate.sorted {  $0.key < $1.key }
//        costByDate.keys = costByDate.keys.sorted {  $0.key < $1.key }

    }
}
