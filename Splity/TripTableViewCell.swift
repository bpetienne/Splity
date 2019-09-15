//
//  TripTableViewCell.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 17/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet weak var tripDestinationLabel: UILabel!
    @IBOutlet weak var tripPeriodLabel: UILabel!
    @IBOutlet weak var tripTotalAmount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelStackView: UIStackView!
    
    var imageData: Data? {
        didSet{
            //tripImage = nil
            if tripImage != nil {
                fetchImage()
            }
        }
    }
    
    static let identifier = "TripTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     static let MaxPhotoWidth: CGFloat = 600
    
    func fetchImage()
    {
        intializeNewImage()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = self?.imageData,  let image =  UIImage(data: data){
                
                if image.size.width > TripTableViewCell.MaxPhotoWidth {
                    if let image = image.resize(toWidth: TripTableViewCell.MaxPhotoWidth){
                        DispatchQueue.main.async {
                            self?.setNewImage(image: image)
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self?.setNewImage(image: image)
                    }
                }
            }
        }
    }
    
    func intializeNewImage() {
        activityIndicator.startAnimating()
        labelStackView.isHidden = true
        self.tripImage.image = nil
    }
    
    func setNewImage(image: UIImage?) {
        UIView.transition(with: self.tripImage,
                          duration:0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.tripImage.image = self.setFilter(image: image) },
                          completion: nil)
        
        
        //tripImage.image = setFilter(image: image)
        activityIndicator.stopAnimating()
        labelStackView.isHidden = false

    }

    func setFilter(image: UIImage?) -> UIImage?{
        if  let inputImage = image {
            let context = CIContext(options: nil)
            
            if let currentFilter = CIFilter(name: "CIWhitePointAdjust") {
                let beginImage = CIImage(image: inputImage)
                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                currentFilter.setValue(CIColor(color: Configuration.grayColor80), forKey: kCIInputColorKey)

                
                if let output = currentFilter.outputImage {
                    if let cgimg = context.createCGImage(output, from: output.extent) {
                        let processedImage = UIImage(cgImage: cgimg)
                        return processedImage
                        
                    }
                }
            }
        }
        return image
    }
}
