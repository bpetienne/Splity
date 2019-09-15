//
//  CurrencyService.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/12/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation

class CurrencyService {
    
    func getSpotRate(currency: String) -> Double {
        if let rate = Configuration.Currencies[currency] {
            return rate
        }
        
        return 0
    }
}
