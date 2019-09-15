//
//  LabelTableViewCell.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 21/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: String? {
        didSet {
            // cast the item to appropriate item type
            
            guard  let item = item else {
                return
            }
            label.text = item
        }
    }
    
    static let identifier = "LabelTableViewCell"
    
}
