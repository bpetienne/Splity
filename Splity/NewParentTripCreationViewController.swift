//
//  NewParentTripCreationViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 20/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class NewParentTripCreationViewController: UIViewController, NewTravellerDeletage  {

    var childViewController: NewTripCreationTableViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let child = self.childViewControllers.first as? NewTripCreationTableViewController{
            childViewController = child
            childViewController.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - NewTravellerDeletage
    func updateTravellers(travellerIds: [String]){
        childViewController.updateTravellers(travellerIds: travellerIds)
    }
    
    func addNewTraveller(traveller:Traveller? ){
        
    }

}
