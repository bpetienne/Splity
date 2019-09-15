//
//  MainViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 25/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tc = TestTabPageViewController()
        navigationController?.pushViewController(tc, animated: true)
    }

   


}
