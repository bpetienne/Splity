//
//  CostAnalysisTableViewCell.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 27/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class CostAnalysisTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var amount: UILabel!
    //@IBOutlet weak var percentage: UILabel!

    @IBOutlet weak var PercentageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var item: CostAnalysisAttribute? {
        didSet {
            // cast the item to appropriate item type
            guard  let item = item else {
                return
            }
            groupName.text = item.name
            amount.text = item.amount.toStringWithSeparatorInEuro()
            PercentageConstraint.constant = CGFloat(item.percentage) * contentView.bounds.size.width
            //backgroundColorView.backgroundColor = Configuration.yellowColor
        }
    }
    
    static let identifier = "CostAnalysisTableViewCell"
}
