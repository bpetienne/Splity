//
//  AddDestinationViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 26/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

protocol AddNewTextDelegate: class {
    func updateText(sender: UIViewController, text: String?)
}

class AddNewTextViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: AddNewTextDelegate?
    @IBOutlet weak var destinationText: UITextField!{
        didSet {
            destinationText.delegate = self
            destinationText.setBottomBorder(color: Configuration.textFiledBorderColor)
        }
    }
    
    var vcTitle: String?
    
    var newText: String? {
        return (destinationText != nil && destinationText.text != nil && destinationText.text! != "") ? destinationText.text! : nil
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let vcTitle = vcTitle {
            title = vcTitle
        }
        destinationText.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        destinationText.resignFirstResponder()
        delegate?.updateText(sender: self, text: newText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        return true
    }
    

    func save()
    {
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
       
        
    }


}
