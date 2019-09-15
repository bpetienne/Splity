//
//  CostAnalysisViewModelItem.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 12/08/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit

enum CostAnalysisViewModelItemType {
    case total
    case traveller
    case category
    case paymentType
    case day
}

protocol CostAnalysisViewModelItem {
    var type: CostAnalysisViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String?  { get }
    var sectionAverageLabel: String? { get}
    var height: CGFloat  { get }
    var heightForFooter: CGFloat  { get }
    var heightForHeader: CGFloat  { get }
}

extension CostAnalysisViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var height: CGFloat {
        return CGFloat(40)
    }
    
    var heightForFooter: CGFloat {
        return CGFloat(0)
    }
    
    var heightForHeader: CGFloat {
        return CGFloat(30)
    }
    
    var sectionAverageLabel: String? {
        return nil
    }
    
    var sectionAverageAmount: Decimal {
        return 0
    }
}

class CostAnalysisAttribute{
    var name: String
    var amount: Double
    var percentage: Double
    
    init (name: String, amount: Double, percentage: Double){
        self.name = name
        self.amount = amount
        self.percentage = percentage
    }
}

class CostAnalysisViewModelTotalItem: CostAnalysisViewModelItem {
    var type: CostAnalysisViewModelItemType {
        return .total
    }
    var sectionTitle: String? {
        return "Total"
    }
    
    var costAnalysisAttribute: CostAnalysisAttribute

    init(costAnalysisAttribute: CostAnalysisAttribute) {
        self.costAnalysisAttribute = costAnalysisAttribute
    }
}

class CostAnalysisViewModelCategoryItem: CostAnalysisViewModelItem {
    var type: CostAnalysisViewModelItemType {
        return .category
    }
    var sectionTitle: String? {
        return "Catégorie"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var attributes: [CostAnalysisAttribute]
    
    init(attributes: [CostAnalysisAttribute]) {
        self.attributes = attributes
    }
}

class CostAnalysisViewModelPaymentTypeItem: CostAnalysisViewModelItem {
    var type: CostAnalysisViewModelItemType {
        return .paymentType
    }
    var sectionTitle: String? {
        return "Paiement"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var attributes: [CostAnalysisAttribute]
    
    init(attributes: [CostAnalysisAttribute]) {
        self.attributes = attributes
    }
}

class CostAnalysisViewModelTravellerItem: CostAnalysisViewModelItem {
    var type: CostAnalysisViewModelItemType {
        return .traveller
    }
    var sectionTitle: String? {
        return "Voyageur"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var attributes: [CostAnalysisAttribute]
    
    var averageAmount: Double
    
    init(attributes: [CostAnalysisAttribute], averageAmount: Double) {
        self.attributes = attributes
        self.averageAmount = averageAmount
    }
    
    var sectionAverageLabel: String? {
        return averageAmount.toStringWithSeparatorInEuro() + " / voyageur"
    }
}

class CostAnalysisViewModelDayItem: CostAnalysisViewModelItem {
    var type: CostAnalysisViewModelItemType {
        return .day
    }
    var sectionTitle: String? {
        return "Date"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var attributes: [CostAnalysisAttribute]
    
    var averageAmount: Double
    
    init(attributes: [CostAnalysisAttribute], averageAmount: Double) {
        self.attributes = attributes
        self.averageAmount = averageAmount
    }
    
    var sectionAverageLabel: String? {
        return averageAmount.toStringWithSeparatorInEuro() + " / jour"
    }
}
