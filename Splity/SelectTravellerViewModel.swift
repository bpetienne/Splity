//
//  SelectTravellerViewModel.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 25/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation

class SelectTravellerViewModel{
    var name:String
    var id:String
    var isSelected:Bool=false
    
    init(name: String, id: String, isSelected: Bool = false)
    {
        self.name = name
        self.id = id
        self.isSelected = isSelected
    }
}
