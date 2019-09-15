//
//  CurrencyViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 16/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var currencyList = [String]()
    var selectedCurrency: String?
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        
        if selectedCurrency != nil && currencyList.contains(selectedCurrency!) {
            let selectedRow = currencyList.index(of: selectedCurrency!)
            currencyPickerView.selectRow(selectedRow!, inComponent: 0, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return currencyList.count
    }
    
    //the data to return for the row and component(column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList[row]
    }
    
    
    //Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyList[row]
        
    }
    

    
}
