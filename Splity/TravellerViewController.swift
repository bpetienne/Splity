//
//  TravellerViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 20/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit


extension TravellerViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneNumberTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}



class TravellerViewController: UIViewController {
    
    var traveller: TravellerViewModel?
    var delegate: NewTravellerViewModelDeletage?
    
    @IBOutlet weak var lastNameTextField: UITextField!{
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.setBottomBorder(color: Configuration.textFiledBorderColor)

        }
    }
    @IBOutlet weak var firstNameTextField: UITextField!{
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.setBottomBorder(color: Configuration.textFiledBorderColor)
            
        }
    }
    @IBOutlet weak var phoneNumberTextField: UITextField!{
        didSet {
            phoneNumberTextField.delegate = self
            phoneNumberTextField.setBottomBorder(color: Configuration.textFiledBorderColor)
            
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet {
            emailTextField.delegate = self
            emailTextField.setBottomBorder(color: Configuration.textFiledBorderColor)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.becomeFirstResponder()
        UpdateUI()
       
    }
    
    func UpdateUI(){
        if let traveller = traveller {
            firstNameTextField.text = traveller.firstName
            lastNameTextField.text = traveller.lastName
            phoneNumberTextField.text = traveller.phoneNumber
            emailTextField.text = traveller.email
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
        
        if  traveller != nil {
            traveller!.firstName=firstNameTextField.text
            traveller!.lastName=lastNameTextField.text
            traveller!.phoneNumber=phoneNumberTextField.text
            traveller!.email=emailTextField.text
        }
        
        delegate?.addNewTraveller(sender: self, travellerViewModel: traveller)

    }
    @IBAction func Save(_ sender: UIButton) {
        traveller = TravellerViewModel()
        
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TravellerViewController is not inside a navigation controller.")
        }
    }
}


