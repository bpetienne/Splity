//
//  ButtonTableViewCell.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 21/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
            button.titleLabel?.text = item
        }
    }
    
    static let identifier = "ButtonTableViewCell"

    
}
