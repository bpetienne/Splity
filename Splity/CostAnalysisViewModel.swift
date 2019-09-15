//
//  CostAnalysisViewModel.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 14/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit

class CostAnalysisViewModel: NSObject {
    var items = [CostAnalysisViewModelItem]()

    var total: CostAnalysisViewModelTotalItem!
    var traveller : CostAnalysisViewModelTravellerItem!
    var day: CostAnalysisViewModelDayItem!
    var paymentType: CostAnalysisViewModelPaymentTypeItem!
    var category: CostAnalysisViewModelCategoryItem!

    init(trip: Trip) {
        total = CostAnalysisViewModelTotalItem(costAnalysisAttribute: CostAnalysisAttribute(name: "Total", amount: trip.total, percentage: 0))

        var travellersCostAnalysis = [CostAnalysisAttribute]()
        for cost in trip.costByPeople{
            let name = trip.getTraveller(id: cost.key)?.firstName ?? "???"
            travellersCostAnalysis.append(CostAnalysisAttribute(name: name, amount: cost.value, percentage: cost.value / trip.total))
        }
        traveller = CostAnalysisViewModelTravellerItem(attributes: travellersCostAnalysis, averageAmount: trip.total / Double(travellersCostAnalysis.count))

        var categoriesCostAnalysis = [CostAnalysisAttribute]()
        for cost in trip.costByCategories{
            categoriesCostAnalysis.append(CostAnalysisAttribute(name: cost.key.toDescritpion(), amount: cost.value, percentage: cost.value / trip.total))
        }
        category = CostAnalysisViewModelCategoryItem(attributes: categoriesCostAnalysis)

        var dayCostAnalysis = [CostAnalysisAttribute]()

        for date in trip.costByDate.keys.sorted(by: {$0 < $1}){
            let name = Helper.convertInFrenchDateToStringdMMMMyyyy(date)
            dayCostAnalysis.append(CostAnalysisAttribute(name: name, amount: trip.costByDate[date]!, percentage: trip.costByDate[date]! / trip.total))
        }
        day = CostAnalysisViewModelDayItem(attributes: dayCostAnalysis, averageAmount: trip.total / Double(dayCostAnalysis.count))

        var paymentCostAnalysis = [CostAnalysisAttribute]()
        for cost in trip.costByPayment{
            paymentCostAnalysis.append(CostAnalysisAttribute(name: cost.key.toDescritpion(), amount: cost.value, percentage: cost.value / trip.total))
        }
        paymentType = CostAnalysisViewModelPaymentTypeItem(attributes: paymentCostAnalysis)

        super.init()

        //items.append(total)
        items.append(traveller)
        items.append(category)
        items.append(day)
        items.append(paymentType)
    }

}

extension CostAnalysisViewModel: UITableViewDataSource {
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

        case .total:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CostAnalysisTableViewCell.identifier, for: indexPath) as? CostAnalysisTableViewCell {
                cell.item = total.costAnalysisAttribute
                return cell
            }

        case .traveller:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CostAnalysisTableViewCell.identifier, for: indexPath) as? CostAnalysisTableViewCell {
                cell.item = traveller.attributes[indexPath.row]
                return cell
            }

        case .category:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CostAnalysisTableViewCell.identifier, for: indexPath) as? CostAnalysisTableViewCell {
                cell.item = category.attributes[indexPath.row]
                return cell
            }


        case .day:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CostAnalysisTableViewCell.identifier, for: indexPath) as? CostAnalysisTableViewCell {
                cell.item = day.attributes[indexPath.row]
                return cell
            }

        case .paymentType:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CostAnalysisTableViewCell.identifier, for: indexPath) as? CostAnalysisTableViewCell {
                cell.item = paymentType.attributes[indexPath.row]
                return cell
            }
        }
        // return the default cell if none of above succeed
        return UITableViewCell()
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return items[section].sectionTitle
//    }
}





