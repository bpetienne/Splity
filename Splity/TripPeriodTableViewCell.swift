//
//  TripPeriodTableViewCell.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 23/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class TripPeriodTableViewCell: UITableViewCell {

    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /*var item: TripViewModelItem? {
        didSet {
            // cast the item to appropriate item type
            
            guard let item = item as? TripViewModelPeriodItem else {
                return
            }
            
            beginDateLabel?.text = Helper.convertInFrenchDateToStringdMMMMyyyy(item.beginDate)
            endDateLabel?.text = Helper.convertInFrenchDateToStringdMMMMyyyy(item.endDate)

        }
    }*/
    
    static let identifier = "TripPeriodTableViewCell"

}
