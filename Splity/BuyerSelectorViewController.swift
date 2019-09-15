//
//  BuyerSelectorViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 17/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class BuyerSelectorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    var buyerList = [String]()
    var selectedBuyer: String?
    
    @IBOutlet weak var buyerPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buyerPicker.dataSource = self
        buyerPicker.delegate = self
        
        if selectedBuyer != nil && buyerList.contains(selectedBuyer!) {
            let selectedRow = buyerList.index(of: selectedBuyer!)
            buyerPicker.selectRow(selectedRow!, inComponent: 0, animated: false)
        }

        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    

    
    //the number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //the number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buyerList.count
    }
    
    //the data to return for the row and component(column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return buyerList[row]
    }
    
    
    //Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBuyer = buyerList[row]
    }

}
