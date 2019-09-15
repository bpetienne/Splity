//
//  TripViewModel.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit


class TripViewModel: NSObject {
    
    var items = [TripViewModelItem]()
    var traveller : TripViewModelTravellerItem!
    var destination: TripViewModelDestinationItem!
    var currency: TripViewModelCurrencyItem!
    var period: TripViewModelPeriodItem!
    var photo: TripViewModelPhotoItem!
    var trip: Trip
    
    init(trip: Trip) {
        
        self.trip = trip
        period = TripViewModelPeriodItem(trip: trip)
        destination = TripViewModelDestinationItem(trip: trip)
        currency = TripViewModelCurrencyItem(trip: trip)
        traveller = TripViewModelTravellerItem(trip: trip)
        photo = TripViewModelPhotoItem(trip: trip)
        
        super.init()
        
        items.append(photo)
        items.append(period)
        items.append(destination)
        items.append(currency)
        items.append(traveller)
    }
}

extension TripViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we will configure the cells here
        
        let item = items[indexPath.section]
        switch item.type {
        case .photo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TripPhotoTableViewCell.identifier, for: indexPath) as? TripPhotoTableViewCell {
                cell.item = photo.photo
                return cell
            }
            
        case .period:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TripDateTableViewCell.identifier, for: indexPath) as? TripDateTableViewCell {
                cell.item = period.attributes[indexPath.row]
                
                return cell
            }
        case .destination:
            if indexPath.row == item.rowCount - 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonAsLabelTableViewCell.identifier, for: indexPath) as? ButtonAsLabelTableViewCell {
                    cell.item = item.addButtonTitle
                    return cell
                }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                cell.item = destination.attributes[indexPath.row]
                return cell
            }
            }
        case .currency:
            if indexPath.row == item.rowCount - 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonAsLabelTableViewCell.identifier, for: indexPath) as? ButtonAsLabelTableViewCell {
                    cell.item = item.addButtonTitle
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                    cell.item = currency.attributes[indexPath.row]
                    return cell
                }
            }
        case .traveller:
            if indexPath.row == item.rowCount - 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonAsLabelTableViewCell.identifier, for: indexPath) as? ButtonAsLabelTableViewCell {
                    cell.item = item.addButtonTitle
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                    
                    let name = trip.getTraveller(id: traveller.travellerIds[indexPath.row])?.name
                    cell.item = name ?? "???"
                    
                    return cell
                }
            }
        }
        // return the default cell if none of above succeed
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        let item = items[indexPath.section]
        
        switch item.type {
        case .currency:
            return indexPath.row < item.rowCount - 1
            
        case .destination:
            return indexPath.row < item.rowCount - 1
            
        default:
            return false
        }
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let item = items[indexPath.section]
            
            switch item.type {
            case .currency:
                trip.remove(currencyAt: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                //addCurrencyDelegate?.remove(currencyToRemoveAt: indexPath.row)
                
                
            case .destination:
                trip.remove(destinationAt: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                //addDestinationDelegate?.remove(destinationToRemoveAt: indexPath.row)
                
                
            default:
                break
            }
            
        } else if editingStyle == .insert {
            
        }
    }
}


