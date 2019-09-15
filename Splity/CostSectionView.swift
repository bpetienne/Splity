//
//  CostPercentageView.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 12/08/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import UIKit

class CostSectionView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.textColor = Configuration.sectionTextColor35
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel!{
        didSet{
            subtitleLabel.textColor = Configuration.sectionTextColor35
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //contentView.backgroundColor = Configuration.grayLevelColor
        contentView.backgroundColor = Configuration.sectionColor

    }
    
    static let identifier = "CostSectionView"
}
