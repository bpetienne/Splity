//
//  ParentTravellerTableViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 20/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log



extension TravellerTableViewController: NewTravellerViewModelDeletage{
    
    func addNewTraveller(sender: UIViewController, travellerViewModel:TravellerViewModel? ){
        if let traveller = travellerViewModel{
            let newTraveller = Traveller( firstName:traveller.firstName ?? "", lastName:traveller.lastName ?? "", email:traveller.email ?? "",travellerId: traveller.travellerId)
            trip.add(traveller: newTraveller)
            
            let newSelectTravellerViewModel = SelectTravellerViewModel(name: newTraveller.name, id: newTraveller.travellerId, isSelected: true)
            travellers.append(newSelectTravellerViewModel)
        }
    }
}


class TravellerTableViewController: UIViewController  {

    // MARK: - SegueIdentifiers
    fileprivate enum SegueIdentifier: String {
        case AddNewTraveller
    }
    
    var travellers:[SelectTravellerViewModel]!

    var trip: Trip!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        if let travellersModel = trip.modelDelegate?.allTravellers.values{
            travellers = [SelectTravellerViewModel]()

            for traveller in travellersModel {
                let user = SelectTravellerViewModel(name: traveller.name, id: traveller.travellerId)
                user.isSelected = trip.travellers.contains{$0.key == user.id}
                travellers.append(user)
            }
            
            travellers = travellers.sorted {$0.name < $1.name}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let travellerIds = travellers?.filter(){$0.isSelected}.map(){$0.id}
        
        if let travellerIds = travellerIds {
            trip.update(travellerIds: travellerIds)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case SegueIdentifier.AddNewTraveller.rawValue:
            if let destinationViewController = segue.destination as? TravellerViewController{
                destinationViewController.delegate = self
                return
            }
           
        default:
            os_log("no segue identifier.", log: OSLog.default, type: .debug)
        }
    }
}

extension TravellerTableViewController: UITableViewDelegate, UITableViewDataSource  {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let selectedTraveller = travellers[indexPath.row ]
        selectedTraveller.isSelected = !selectedTraveller.isSelected
        tableView.reloadData()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if travellers == nil {
            return 0
        }
        return travellers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SelectTravellerTableViewCell"
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectTravellerTableViewCell   else {
            fatalError("The dequeued cell is not an instance of SelectTravellerTableViewCell.")
        }
        
        let traveller = travellers[indexPath.row]
        cell.travellerNameLabel.text = traveller.name
        if traveller.isSelected{
            cell.accessoryType =  .checkmark
            cell.backgroundColor = Configuration.grayColor85
        }
        else {
            cell.accessoryType =  .none
            cell.backgroundColor = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedTraveller = travellers[indexPath.row]
            if trip.travellerIsUsed(travellerId: selectedTraveller.id) == true {
                let dialogMessage = UIAlertController(title: "Confirm", message: "Cette personne est utilisée dans un ou plusieurs voyages. Etes-vous sûr de vouloir la supprimer?", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    self.deleteRecord(tableView, forRowAt: indexPath)
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    print("Cancel button tapped")
                }
                
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                self.present(dialogMessage, animated: true, completion: nil)

            }
            else {
                deleteRecord(tableView, forRowAt: indexPath)

//                travellers.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                trip.travellerDelegate?.tryRemoveTraveller(travellerId: selectedTraveller.id)
            }


            
        }
    }
    
    func deleteRecord(_ tableView: UITableView, forRowAt indexPath: IndexPath)
    {
        print("Deleting text now")
        let selectedTraveller = travellers[indexPath.row]
        travellers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        trip.tryRemoveTraveller(travellerId: selectedTraveller.id)

    }
}
