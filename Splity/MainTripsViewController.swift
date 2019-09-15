//
//  MainTripsViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 19/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
class MainTripsViewController: UIViewController {

    // MARK: - SegueIdentifiers
    fileprivate enum SegueIdentifier: String {
        case AddNewTripSegue
        case ShowTripDetailSegue

    }
    
    var model = Model()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var isVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        SetButtonCorner()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isVisible = true
        //UIApplication.shared.statusBarStyle = .lightContent
        model.sortedModel()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return isVisible ? .lightContent : .default
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isVisible = false
        //UIApplication.shared.statusBarStyle = .default
    }
    
    
    @IBAction func unwindToMainController(segue: UIStoryboardSegue){
        
        var shouldSave = false
        
        if let trip = model.selectedTrip {
            if trip.isModified {
                shouldSave = true
                trip.isModified = false
            }
        }
        
        if shouldSave {
            model.saveModelInJson()
        }
        
    }
    
    @IBAction func addNewTrip(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func cancelNewTrip(segue: UIStoryboardSegue){
        
        if let vc =  segue.source as? TripViewController{
            if let trip = vc.trip {
                model.deleteTripAndSave(id: trip.tripId)
            }
        }
    }


    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case SegueIdentifier.AddNewTripSegue.rawValue:
            os_log("Adding a new trip.", log: OSLog.default, type: .debug)
            if let destinationViewController = segue.destination.contents as? TripViewController  {
//                let costLoaderService = CostLoaderService()
//                let costs = costLoaderService.importCosts2()
                let newTrip = Trip(in: model)
                destinationViewController.trip =  newTrip
//                newTrip.costs = costs
                destinationViewController.hideButtonValidate = false
                model.selectedTrip = newTrip
            }
            
        case SegueIdentifier.ShowTripDetailSegue.rawValue:
            if let destinationViewController = segue.destination.contents as? TripTabBarController  {
                if let selectedTripCell = sender as? TripTableViewCell  {
                    if let indexPath = tableView.indexPath(for: selectedTripCell)  {
                        model.selectedTrip = model.trips[indexPath.row]
                        destinationViewController.trip = model.selectedTrip
                    }
                }
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "sender is nil")")
        }
        
    }
    
    
    func saveCompletion(){
        self.tableView.reloadData()
    }
    
}



extension MainTripsViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier, for: indexPath) as? TripTableViewCell   else {
            fatalError("The dequeued cell is not an instance of TripTableViewCell.")
        }
       
        let trip = model.trips[indexPath.row]
        return fillCellWithTrip(cell: cell, with: trip)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        print("row : \(row)")
        print("section : \(section)")
    }
    
    func fillCellWithTrip(cell: TripTableViewCell, with trip: Trip) -> TripTableViewCell {
        
        
        
        cell.imageData = trip.imageData
        cell.tripDestinationLabel.text = trip.mainCountry?.uppercased()
        cell.tripTotalAmount.text = "\(trip.total.toStringWithSeparatorInEuro()) (\(trip.totalPerDayPerPerson.toStringWithSeparatorInEuro()) / pers. / j.)"
        cell.tripDestinationLabel.font = UIFont(name: trip.randomFont, size: CGFloat(35))

        let monthBegin = trip.beginDate.getShortMonth()
        let monthEnd =  trip.endDate.getShortMonth()
        let dayBegin = trip.beginDate.getDay()
        let dayEnd =  trip.endDate.getDay()
        let endYear =  trip.endDate.toYear()
        
        if trip.beginDate == trip.endDate {
            cell.tripPeriodLabel.text = "\(dayBegin) \(monthBegin) \(endYear)"
        }
        else if monthBegin == monthEnd {
            cell.tripPeriodLabel.text = "\(dayBegin)-\(dayEnd)  \(monthEnd) \(endYear)"
        }
        else {
            cell.tripPeriodLabel.text = "\(dayBegin) \(monthBegin) - \(dayEnd)  \(monthEnd) \(endYear)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            model.deleteTripAndSave(id: model.trips[indexPath.row].tripId)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
}


extension MainTripsViewController {
    func SetButtonCorner(){
        // Do any additional setup after loading the view.
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize.init(width: CGFloat(5), height: CGFloat(5))
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 5
        addButton.layer.cornerRadius = 20//0.1 * addButton.bounds.size.width
    }
}
