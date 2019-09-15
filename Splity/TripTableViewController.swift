//
//  TripTableViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 17/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log
import CloudKit
//import Notification

class TripTableViewController: UITableViewController {

    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //MARK: Actions
   
    func tripSavingCompletion(){
        tableView.reloadData()
    }
    
    @IBAction func unwindToMainController(segue: UIStoryboardSegue){
        
    }

    
    @IBAction func cancelToTripList(sender: UIStoryboardSegue) {
        
    }

    @IBAction func saveToTripList(sender: UIStoryboardSegue) {
        
        var shouldSave = false
        //if let sourceViewController = sender.source as? TripViewController, let trip = sourceViewController.trip {
        if  sender.source is TripViewController{
            if /*let sourceViewController = sender.source as? TripViewController, */ let trip = selectedTrip {

                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update an existing trip.
                    if trip.isModified {
                        shouldSave = true
                        trip.isModified = false
                    }
                    model.trips[selectedIndexPath.row] = trip
                    
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    // Add a new trip.
                    let newIndexPath = IndexPath(row: model.trips.count, section: 0)
                    if trip.isModified {
                        shouldSave = true
                        trip.isModified = false
                    }
                    model.trips.append(trip)
                    model.tripsUUID.append(trip.tripId)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }

        }
        
        
        if shouldSave {
            model.saveModelInJson()

        }
        
    }

  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TripTableViewCell"
        
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TripTableViewCell   else {
            fatalError("The dequeued cell is not an instance of TripTableViewCell.")
        }
            
        
        
            // Fetches the appropriate meal for the data source layout.
            let trip = model.trips[indexPath.row]
            
            cell.tripImage.image = trip.photo
            cell.tripDestinationLabel.text = trip.mainCountry?.uppercased()
        
            let calendar = Calendar.current
            
            let dayBegin = calendar.component(.day, from: trip.beginDate)
            let dayEnd = calendar.component(.day, from: trip.endDate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            
            var monthBegin = dateFormatter.string(from: trip.beginDate)
            var monthEnd = dateFormatter.string(from: trip.endDate)
            
            

        
        monthBegin = String(monthBegin[..<monthBegin.index(monthBegin.startIndex, offsetBy: 3)])

        monthEnd = String(monthEnd[..<monthEnd.index(monthEnd.startIndex, offsetBy: 3)])

        
        if trip.beginDate == trip.endDate {
            cell.tripPeriodLabel.text = "\(dayBegin) \(monthBegin)."
        }
        
        else if monthBegin == monthEnd {
            cell.tripPeriodLabel.text = "\(dayBegin)-\(dayEnd)  \(monthEnd)."
        }
        else {
            cell.tripPeriodLabel.text = "\(dayBegin) \(monthBegin). - \(dayEnd)  \(monthEnd)."
        }
        
        
            return cell
            
            
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if let index = model.tripsUUID.index(of: model.trips[indexPath.row].tripId){
                model.tripsUUID.remove(at: index)
            }

            model.deleteTripsUUID.append(model.trips[indexPath.row].tripId)
            model.trips.remove(at: indexPath.row)
            model.saveModelInJson()

            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    var selectedTrip: Trip?
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddNewTripSegue":
            os_log("Adding a new trip.", log: OSLog.default, type: .debug)
            if let destinationViewController = segue.destination as? TripViewController  {
                
                let newTrip = Trip(in: model)
                destinationViewController.trip =  newTrip
                destinationViewController.hideButtonValidate = false
                model.selectedTrip = newTrip
                selectedTrip = model.selectedTrip
            }
            
        case "ShowTripDetailSegue":
            if let destinationViewController = segue.destination as? TripTabBarController  {
                if let selectedTripCell = sender as? TripTableViewCell  {
                    if let indexPath = tableView.indexPath(for: selectedTripCell)  {
                        model.selectedTrip = model.trips[indexPath.row]
                        selectedTrip = model.selectedTrip
                        destinationViewController.trip = selectedTrip
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

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification!")

    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.removeObserver(self)

    }

}
