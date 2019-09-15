//
//  TripPhotoTableViewCell.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 26/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class TripPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: UIImage? {
        didSet {
            // cast the item to appropriate item type
            
            guard let item = item  else {
                return
            }
            
            photoImageView.image = item
        }
    }
    
    static let identifier = "TripPhotoTableViewCell"
    
}
