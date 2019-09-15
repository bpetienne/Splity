//
//  MyCostTableViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 04/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log


class MyCostTableViewController: UITableViewController {
    
    //MARK: Properties
    var costsByDate = [[Cost]]()
    var costs = [Cost]()
    var allDates: [Date] = [Date]()
    
    var trip: Trip!
    
    
    
        
        //MARK: Actions
        
//        @IBAction func cancelToCostList(sender: UIStoryboardSegue) {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                tableView.reloadRows(at: [selectedIndexPath], with: .fade)
//            }
//        }
//        
//        @IBAction func saveToCostList(sender: UIStoryboardSegue) {
//            
//            if let sourceViewController = sender.source as? CostViewController, let cost = sourceViewController.cost {
//                
//                if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                    // Update an existing cost.
//                    costsByDate[selectedIndexPath.section][selectedIndexPath.row] = cost
//                    costs = costsByDate.flatMap {$0}
//                    
//                }
//                else {
//                    costs.append(cost)
//                }
//                
//                createCostsByDate()
//                tableView.reloadData()
//                
//                trip.updateCosts(costs: costs)
//                
//            }
//        }
        
        
        
        // MARK: - Override function
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let nib = UINib(nibName: "MyCostTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "MyCostTableViewCell")
            createCostsByDate()
            tableView.tableFooterView = UIView()
        }
    
    
    
    
    
    
    
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            
            
            switch(segue.identifier ?? "") {
            case "AddCost":
                os_log("Adding a new cost.", log: OSLog.default, type: .debug)
                
                
            case "ShowMyCostDetail":
                guard let costDetailViewController = segue.destination as? CostViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedCost = sender as? Cost else {
                    fatalError("Unexpected sender: \(sender ?? "sender is nil")")
                }
                
                costDetailViewController.cost = selectedCost
                costDetailViewController.trip = trip


                //animatedBackgroundColor()
                
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "sender is nil")")
            }
        }
    
    func animatedBackgroundColor(){
        UIView.animate(withDuration: TimeInterval(1)) {
            self.view.backgroundColor = UIColor.gray
            
        }
    }
        
        @IBAction func returnToTrip(_ sender: UIBarButtonItem) {
            let isPresentingInAddMealMode = presentingViewController is UINavigationController
            
            if isPresentingInAddMealMode {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The MealViewController is not inside a navigation controller.")
            }
        }
        
        // MARK: Private function
        
        private func getDateWithoutTime(_ date: Date) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateStyle = DateFormatter.Style.short
            let newDate = dateFormatter.date(from: dateFormatter.string(from: date))!
            return newDate
        }
        
        private func createCostsByDate() {
            let dates = costs.map ( {(c: Cost) -> Date in
                return getDateWithoutTime(c.date)})
            allDates = [Date](Set(dates)).sorted()
            costsByDate = [[Cost]]()
            for date in allDates {
                let da = costs.filter({ (c:Cost) -> Bool in
                    getDateWithoutTime(c.date) == date
                })
                costsByDate += [da]
            }
            
        }

    
    
    
    
}



extension MyCostTableViewController {
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return costsByDate.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return costs.count
        
        if costsByDate.count > section {
            return costsByDate[section].count
            
        }
        return 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = allDates[section]
        let token = Helper.convertInFrenchDateToStringdMMMMyyyy(date)
        return token
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MyCostTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CostTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MyCostTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        //let cost = costs[indexPath.row]
        let cost = costsByDate[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = cost.name
        cell.amountLabel.text = "\(cost.amount)".replacingOccurrences(of: ".", with: ",")
        cell.currencyLabel.text = cost.currency
        cell.buyerLabel.text = cost.buyerShortName
        
        if let image = Configuration.PaymentImages[cost.payment] {
            cell.paymentTypeImageView.image = image
        }
        if let image = Configuration.ConcernedPeopleImages[cost.concernedPeople] {
            cell.concernedPeopleImageView.image = image
        }
        
        if let category = cost.category,  let categoryInformation = Configuration.informationForCategory[category] {
            cell.photoImageView.image = categoryInformation.image
            cell.categoryLabel.text = categoryInformation.label
        }
        
        //cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        //cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            costsByDate[indexPath.section].remove(at: indexPath.row)
            costs = costsByDate.flatMap {$0}
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (costsByDate[indexPath.section].count == 0) {
                costsByDate.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            tableView.endUpdates()
            
            
            trip.updateCosts(costs: costs)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String!{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from:allDates[section])
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCost = costsByDate[indexPath.section][indexPath.row]
        
        self.performSegue(withIdentifier: "ShowMyCostDetail", sender: selectedCost)
    }
}

