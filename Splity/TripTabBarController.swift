//
//  UITabBarViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 03/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log




class TripTabBarController: UITabBarController {

    // MARK: - SegueIdentifiers
    fileprivate enum SegueIdentifier: String {
        case ShowCostsInTableView
    }
    
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        for viewController in self.viewControllers! {
            if let tabViewController = viewController.contents as? CostTableViewController  {
                tabViewController.trip = trip
            }
            
            if let tabViewController = viewController.contents as? TripViewController  {
                tabViewController.trip = trip
                tabViewController.hideButtonValidate = true
            }
    
            if let tabViewController = viewController.contents as? NoteViewController  {
                tabViewController.trip = trip
            }
            
            if let tabViewController = viewController.contents as? CostAnalysisTableViewController  {
                tabViewController.trip = trip
            }
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if let mainCountry = trip?.mainCountry {
            self.title = mainCountry
        }
    
    }

}
