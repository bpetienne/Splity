//
//  Extansion.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 27/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit



extension UITableViewController{
    func nibRegister(identifier: String){
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    } 
}
