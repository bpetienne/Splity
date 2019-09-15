//
//  TripViewModelItems.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit


enum TripViewModelItemType {
    case period
    case destination
    case currency
    case traveller
    case photo
}

protocol TripViewModelItem {
    var type: TripViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String?  { get }
    var addButtonTitle: String?  { get }
    
    var height: CGFloat  { get }
    var heightForFooter: CGFloat  { get }
    var heightForHeader: CGFloat  { get }
}

extension TripViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var addButtonTitle: String? {
        return nil
    }
    
    var height: CGFloat {
        return CGFloat(40)
    }
    
    var heightForFooter: CGFloat {
        return CGFloat(15)
    }
    
    var heightForHeader: CGFloat {
        return CGFloat(15)
    }
    
}


class DateAttribute{
    var date: Date
    var label: String
    
    init (label: String, date: Date){
        self.label=label
        self.date=date
    }
    
}


class TripViewModelPeriodItem: TripViewModelItem {
    var trip: Trip
    init (trip: Trip){
        self.trip = trip
    }
    
    var type: TripViewModelItemType {
        return .period
    }
    var sectionTitle: String? {
        return "Période"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var beginDate: Date {return trip.beginDate }
    var endDate: Date {return trip.endDate}
    
    
    var attributes: [DateAttribute]
    {
        return [DateAttribute(label: "Du", date: beginDate), DateAttribute(label: "Au", date: endDate)]
    }
}





class TripViewModelDestinationItem: TripViewModelItem {
    var trip: Trip
    init (trip: Trip){
        self.trip = trip
        
    }
    
    var type: TripViewModelItemType {
        return .destination
    }
    var sectionTitle: String? {
        return "Destinations"
    }
    
    var addButtonTitle: String? {
        return "Ajouter une destination"
    }
    var rowCount: Int {
        return attributes.count + 1
    }
    
    var attributes: [String] {
        return trip.countries
    }
}



class TripViewModelCurrencyItem: TripViewModelItem {
    var trip: Trip
    init (trip: Trip){
        self.trip = trip
    }
    
    
    var type: TripViewModelItemType {
        return .currency
    }
    var sectionTitle: String? {
        return "Devises"
    }
    var addButtonTitle: String? {
        return "Ajouter une devise"
    }
    
    var rowCount: Int {
        return attributes.count + 1
    }
    
    var attributes: [String] {return trip.currencies}
    
}



class TripViewModelTravellerItem: TripViewModelItem {
    var trip: Trip
    init (trip: Trip){
        self.trip = trip
    }
    
    
    var type: TripViewModelItemType {
        return .traveller
    }
    var sectionTitle: String? {
        return "Voyageurs"
    }
    var addButtonTitle: String? {
        return "Ajouter un voyageur"
    }
    
    var rowCount: Int {
        return travellerIds.count + 1
        
    }
    var travellerIds : [String] {return trip.travellers.values.map {$0.travellerId} }
    
}



class TripViewModelPhotoItem: TripViewModelItem {
    
    var trip: Trip
    init (trip: Trip){
        self.trip = trip
    }
    
    
    var type: TripViewModelItemType {
        return .photo
    }
    var sectionTitle: String? {
        return nil
    }
    
    var height: CGFloat {
        return 150
    }
    
    var heightForHeader: CGFloat {
        return CGFloat(0.0001)
    }
    
    var photo : UIImage? {return trip.photo}
    
}




