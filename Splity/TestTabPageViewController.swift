//
//  TabPageViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 25/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import UIKit

class TestTabPageViewController: TabPageViewController {

    
    override init() {
        super.init()
        //let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentCostTableViewController")
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CostAnalysisTableViewController")
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteViewController")
        let vc4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripViewController")

        tabItems = [ (vc2, "Bilan"), (vc3, "Notes"), (vc4, "Paramètres")]
        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        option.hidesTopViewOnSwipeType = .all
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
