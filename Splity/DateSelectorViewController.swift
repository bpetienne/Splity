//
//  DateSelectorViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 11/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit






class DateSelectorViewController: UIViewController, UINavigationControllerDelegate {

   
    
    @IBOutlet weak var costDatePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel! 
    weak var delegate: DateSelectorViewControllerDelegate?
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSizeWithTraitCollection(traitCollection: self.traitCollection)

        if selectedDate == nil {
            selectedDate = Date(timeIntervalSinceNow: 0)
        }
        
        costDatePicker?.date = selectedDate!
        
        updateDispay()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
       
    }
    
    

    @IBAction func cancel(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: cancelCompletion)
    }
    
    var cancelCompletion : (() -> Void)? = nil
    
    
    @IBAction func validate(_ sender: UIButton) {
        delegate?.selectedDate(sender: self, date: selectedDate)
    }
    
    
    
    func updatePreferredContentSizeWithTraitCollection(traitCollection: UITraitCollection){
        self.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: traitCollection.verticalSizeClass == .compact ? 270 : 420);
    }
    
    
    func updateDispay(){
        if costDatePicker != nil {
            selectedDate = costDatePicker?.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM yyyy"
            dateLabel?.text = dateFormatter.string(from: selectedDate!)
        }
       

    }

    @IBAction func changeDate(_ sender: UIDatePicker) {
        updateDispay()
    }
}
