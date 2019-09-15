//
//  NewTripCreationTableViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 20/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class NewTripCreationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DateSelectorViewControllerDelegate, AddNewTextDelegate {
    
    // MARK: - SegueIdentifiers
    fileprivate enum SegueIdentifier: String {
        case SelectTraveller
        case AddDestination
        case AddCurrency
        case PushToDateSelectorSegue
    }
    
    var updatedList: UpdatedList?
    
    enum UpdatedList{
        case currency
        case country
    }
    
    

    var tripViewModel: TripViewModel?
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let trip = trip {
            tripViewModel =  TripViewModel(trip: trip)
            tableView?.dataSource = tripViewModel
        }
        

        nibRegister(identifier: ButtonTableViewCell.identifier)
        nibRegister(identifier: LabelTableViewCell.identifier)
        nibRegister(identifier: ButtonAsLabelTableViewCell.identifier)
        nibRegister(identifier: TripPeriodTableViewCell.identifier)
        nibRegister(identifier: TripDateTableViewCell.identifier)
        nibRegister(identifier: TripPhotoTableViewCell.identifier)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        updatedList = nil
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let item = tripViewModel?.items[indexPath.section]{
            return item.height
        }
        return 0

    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let item = tripViewModel?.items[section]{
            return item.heightForFooter
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let item = tripViewModel?.items[section]{
            return item.heightForHeader
        }
        return 0
    }
    
    
    var selectedIndexPath: IndexPath?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = tripViewModel?.items[indexPath.section]{
            
                switch item.type {
                // do appropriate action for each type
                case .photo:
                    let imagePickerController = UIImagePickerController()
                    // Only allow photos to be picked, not taken.
                    imagePickerController.sourceType = .photoLibrary
                    // Make sure ViewController is notified when the user picks an image.
                    imagePickerController.delegate = self
                    present(imagePickerController, animated: true, completion: nil)
                    
                case .period:
                    selectedIndexPath = indexPath
                    self.performSegue(withIdentifier: SegueIdentifier.PushToDateSelectorSegue.rawValue, sender: self)
                    
                case .destination:
                    if indexPath.row == item.rowCount - 1 {
                        self.performSegue(withIdentifier: SegueIdentifier.AddDestination.rawValue, sender: self)
                    }
                case .currency:
                    if indexPath.row == item.rowCount - 1 {
                        self.performSegue(withIdentifier: SegueIdentifier.AddCurrency.rawValue, sender: self)
                    }
                case .traveller:
                    if indexPath.row == item.rowCount - 1 {
                        self.performSegue(withIdentifier: SegueIdentifier.SelectTraveller.rawValue, sender: self)
                    }
            }
            
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let item = tripViewModel?.items[indexPath.section]{
                
                switch item.type {
                case .currency:
                    trip?.remove(currencyAt: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                case .destination:
                    trip?.remove(destinationAt: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                default:
                    break
                }
                
            }
            
        }
        
    }

    
    
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case SegueIdentifier.SelectTraveller.rawValue :
            
            if let destinationViewController = segue.destination as? TravellerTableViewController{
                destinationViewController.trip = trip
            }
            
        case SegueIdentifier.AddCurrency.rawValue :
            if let destinationViewController = segue.destination as? AddNewTextViewController {
                updatedList = .currency
                destinationViewController.delegate = self
                destinationViewController.vcTitle = "Ajout d'une devise"
                return
            }
        case SegueIdentifier.AddDestination.rawValue :
            if let destinationViewController = segue.destination as? AddNewTextViewController{
                updatedList = .country
                destinationViewController.delegate = self
                destinationViewController.vcTitle = "Ajout d'une destination"

                return
            }
        case SegueIdentifier.PushToDateSelectorSegue.rawValue :
            if let destinationViewController = segue.destination as? DateSelectorViewController{
                if let indexPath = selectedIndexPath,  let item = tripViewModel?.items[indexPath.section]{
                    if item.type == .period{
                        destinationViewController.delegate = self
                        if let item = item as? TripViewModelPeriodItem{
                            destinationViewController.selectedDate = item.attributes[indexPath.row].date
                            if let index = selectedIndexPath{
                                tableView.deselectRow(at: index, animated: true)
                            }
                        }
                    }
                }
                return
            }
            
        default:
            return
        }
    }
    

    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        trip?.add(image: selectedImage)

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func selectedDate(sender: DateSelectorViewController, date:Date?)
    {
        if let date = date {
            
            if let indexPath = selectedIndexPath,  let item = tripViewModel?.items[indexPath.section]{
                if item.type == .period{
                    if indexPath.row == 0 {
                        trip?.update(beginDate: date)
                        tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                    else if indexPath.row == 1 {
                        trip?.update(endDate: date)
                        tableView.reloadRows(at: [indexPath], with: .fade)

                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    
    func  cancelCompletion(){
        if let index = selectedIndexPath{
            tableView.deselectRow(at: index, animated: true)
        }
    }

    
    @IBAction func unwindToNewTripCreationViewController(segue: UIStoryboardSegue){

    }
    
    
    func updateText(sender: UIViewController, text: String?) {
        
        if let updatedList = updatedList, let text=text {
            switch updatedList {
            case .currency:
                trip?.add(currency:text )
            case .country:
                trip?.add(destination:text )
            }
        }
        updatedList = nil
    }
}
