//
//  CostAnalysisTableViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 27/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit



class CostAnalysisTableViewController: UITableViewController {

    var costAnalysisViewModel: CostAnalysisViewModel?
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nibRegister(identifier: CostAnalysisTableViewCell.identifier)
        tableView.tableFooterView = UIView()

        let nib = UINib(nibName: CostSectionView.identifier, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: CostSectionView.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let total = trip?.total {
            self.navigationItem.title = "Bilan            " + total.toStringWithSeparatorInEuro()
        }
        
        if let trip = trip {
            costAnalysisViewModel = CostAnalysisViewModel(trip: trip)
            tableView.dataSource = costAnalysisViewModel
        }
        tableView.delegate = self
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    // MARK: - Table view  delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:  CostSectionView.identifier) as? CostSectionView  else {
            fatalError("The dequeued header/footer is not an instance of CostSectionView.")}
        
        if let item = costAnalysisViewModel?.items[section]{
            headerView.titleLabel.text = item.sectionTitle?.uppercased()
            headerView.subtitleLabel.text = item.sectionAverageLabel?.uppercased()
        }

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = costAnalysisViewModel?.items[indexPath.section]{
            return item.height
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let item = costAnalysisViewModel?.items[section]{
            return item.heightForFooter
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let item = costAnalysisViewModel?.items[section]{
            return item.heightForHeader
        }
        return 0
    }
}
