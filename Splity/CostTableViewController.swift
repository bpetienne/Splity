//
//  ParentCostTableViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 22/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log




class CostTableViewController: UIViewController {

    // MARK: - SegueIdentifiers
    fileprivate enum SegueIdentifier: String {
        case AddNewCost
        case ShowMyCostsInTableView
        case ShowMyCostDetail
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    //MARK: Properties
    var costsByDate = [[Cost]]()
    var allDates: [Date] = [Date]()
    var trip: Trip?
    var tempURL:URL?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize.init(width: CGFloat(5), height: CGFloat(5))
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 5
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        
        
        let nib = UINib(nibName: "MyCostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyCostTableViewCell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        tableView.dataSource = self
        tableView.delegate = self
        
        createCostsByDate()

        let nib2 = UINib(nibName: CostSectionView.identifier, bundle: nil)
        tableView.register(nib2, forHeaderFooterViewReuseIdentifier: CostSectionView.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeader()
    }
    
    func updateHeader(){
        if let total = trip?.total {
            self.navigationItem.title = "Dépenses      " + total.toStringWithSeparatorInEuro()
        }
    }
    //MARK: Actions
    
    @IBAction func cancelToCostList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        }
    }
    
    @IBAction func saveToCostList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? CostViewController, let cost = sourceViewController.cost {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing cost.
                costsByDate[selectedIndexPath.section][selectedIndexPath.row] = cost
                trip?.costs = costsByDate.flatMap {$0}
                
            }
            else {
                trip?.costs.append(cost)
            }
            
            createCostsByDate()
            tableView.reloadData()
            
            //still needed?
            trip?.updateCosts(costs: trip!.costs)
            updateHeader()
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {
        case SegueIdentifier.ShowMyCostDetail.rawValue, SegueIdentifier.AddNewCost.rawValue:
            
            if let costViewController = segue.destination as? CostViewController {
                
                if let trip = trip {
                    costViewController.trip = trip
                }
                
                if let selectedCost = sender as? Cost  {
                    costViewController.cost = selectedCost
                }
            }
        default:
            os_log("Unexpected Segue Identifier.", log: OSLog.default, type: .debug)
        }
        

    }

    
    @IBAction func share(_ sender: UIBarButtonItem) {
        
        guard let trip = trip, let url = trip.exportToFileURL() else {
            return
        }
        tempURL = url
        let activityViewController = UIActivityViewController(
            activityItems: ["Voici un Voyage que j'ai créé avec Cost Tracker. Importe-le dans l'app !", url],
            applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = completionHandler
        if let popoverPresentationController = activityViewController.popoverPresentationController{
            popoverPresentationController.barButtonItem = sender
        }
        present(activityViewController, animated: true, completion: nil )
        
    }
    
    
    func completionHandler(activityType: UIActivityType?, test: Bool,activityItems: [Any]?,error: Error?){
        if let url = tempURL  {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Failed to remove item from Inbox")
            }
        }
    }
    
    func animatedBackgroundColor(){
        UIView.animate(withDuration: TimeInterval(1)) {
            self.view.backgroundColor = UIColor.gray
            
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
       
        if let trip = trip {
            let dates = trip.costs.map ( {(c: Cost) -> Date in
                return getDateWithoutTime(c.date)})
            allDates = [Date](Set(dates)).sorted()
            costsByDate = [[Cost]]()
            for date in allDates {
                let da = trip.costs.filter({ (c:Cost) -> Bool in
                    getDateWithoutTime(c.date) == date
                })
                costsByDate += [da]
            }
        }
    }
    
}


extension CostTableViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return costsByDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return costs.count
        
        if costsByDate.count > section {
            return costsByDate[section].count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:  CostSectionView.identifier) as? CostSectionView  else {
            fatalError("The dequeued header/footer is not an instance of CostSectionView.")}
        let date = allDates[section]
        let name = Helper.convertInFrenchDateToStringdMMMMyyyy(date)
        headerView.titleLabel.text = name.uppercased()
        headerView.subtitleLabel.text = nil

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        let date = allDates[section]
//        let token = Helper.convertInFrenchDateToStringdMMMMyyyy(date)
//        return token
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            costsByDate[indexPath.section].remove(at: indexPath.row)
            trip?.costs = costsByDate.flatMap {$0}
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (costsByDate[indexPath.section].count == 0) {
                costsByDate.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            
            tableView.endUpdates()
            
            //still needed?
            trip?.updateCosts(costs: trip!.costs)
            updateHeader()

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCost = costsByDate[indexPath.section][indexPath.row]
        
        self.performSegue(withIdentifier: "ShowMyCostDetail", sender: selectedCost)
    }
}
