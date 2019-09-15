//
//  CostViewController
//  CostTracker
//
//  Created by Benoit ETIENNE on 03/04/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit
import os.log

//@IBDesignable
class CostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var categoryStackView: UIStackView!
    
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cashButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var costView: CostView!

    @IBOutlet var buttons: [UIButton]!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false

    
    var trip: Trip!
    var cost: Cost?
    var currentCategory : Category?
    var currentPayment : Payment? = .Card
    var currentConcernedPeople : ConcernedPeople? = .Group
    
    var currentDate: Date?
    var currentCurrency: String?
    var currentBuyerId: String?
    var currentBuyerName: String?
    var currentBuyerShortName: String?
    var currentPayedBy: [String]?
    var currentPayedFor: [String]?
    var currentType: CostType? = .Expenditure
    var lowAlpha = CGFloat(0.2)
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBAction func saveToCost(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DateSelectorViewController {
            currentDate = sourceViewController.selectedDate
            updateDateButton()
            
        }
        
        if let sourceViewController = sender.source as? CurrencyViewController {
            currentCurrency = sourceViewController.selectedCurrency
            updateCurrencyButton()
            
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        currentCurrency = trip.currencies.first ?? "EUR"
        currentDate = Date(timeIntervalSinceNow: TimeInterval(0))
        
        if let cost = cost {
            currentCategory = cost.category
            currentBuyerId = cost.buyerId
            currentBuyerShortName = cost.buyerShortName
            
            currentDate = cost.date
            currentPayment = cost.payment
            currentCurrency = cost.currency
            currentConcernedPeople = cost.concernedPeople
            amountLabel.text = "\(cost.amount)".replacingOccurrences(of: ".", with: ",")
            nameTextField.text = cost.name
            updateCategoryButtons(buttonName: cost.category?.toDescritpion())
            if cost.amount != 0 {
                userIsInTheMiddleOfTypingANumber=true
            }
            
            currentBuyerName = trip.getBuyerName(currentBuyerId: currentBuyerId)
            currentType = cost.type
            currentPayedBy = cost.payedBy
            currentPayedFor = cost.payedFor
            
        }
        else {
            selectNextTraveler()
        }
        
        updateDateButton()
        updateConcernedPeopleButtons()
        updatePaymentButtons()
        updateBuyerButton()
        updateCurrencyButton()
        
        nameTextField.delegate = self
        
        updateSaveButtonState()
        updateBackgroundColor()
        updateTextColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
            self.costView.layer.backgroundColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        })    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.costView.layer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setRoundedCorners()
        setRoundedAmountLabel()
        setRoundedCancelAndValidateButton()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
        //Test if it's amount textfield
        //navigationItem.title = textField.text
        
        navigationItem.title = nameTextField.text ?? "New Cost"
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        nameTextField.resignFirstResponder()
        
        if let destinationViewController = segue.destination as? DateSelectorViewController {
            destinationViewController.selectedDate = currentDate
            return
        }
        
        if let destinationViewController = segue.destination as? CurrencyViewController {
            destinationViewController.currencyList = trip.currencies
            destinationViewController.selectedCurrency = currentCurrency
            return
        }
        
        // Configure the destination view controller only when the save button is pressed.
        if let button = sender as? UIButton, button === saveButton{
            let name = nameTextField.text ?? ""
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            let double = formatter.number(from: amountLabel.text ?? "0,0")
            let amount = double?.doubleValue ?? 0.0
            
            cost = Cost(name: name, amount: amount, category: currentCategory, payment: currentPayment!, date: currentDate!, buyerId: currentBuyerId!, buyerShortName: currentBuyerShortName!, currency: currentCurrency!, concernedPeople: currentConcernedPeople!, costId: UUID().uuidString, tripId: trip.tripId, spotEuro: Configuration.Currencies[currentCurrency!] ?? 1, payedBy: [currentBuyerId!], payedFor: trip.travellers.map {$0.key}, type: CostType.Expenditure )
            
            return
        }
    }
    
    
    
    //MARK: Actions
    
    
    
    @IBAction func selectCategory(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        
        if sender.currentTitle == nil {
            return
        }
        
        if let category = Model.categories[sender.currentTitle!] {
            self.currentCategory = category
            updateCategoryButtons(buttonName: sender.currentTitle)
            updateBackgroundColor()
        }
    }
    
    
    
    @IBAction func selectConcernedPeople(_ sender:
        UIButton) {
        nameTextField.resignFirstResponder()
        
        if sender.currentTitle == nil {
            return
        }
        
        let concernedPeople = Model.concernedPeoples[sender.currentTitle!]
        
        if concernedPeople != nil{
            self.currentConcernedPeople = concernedPeople
            updateConcernedPeopleButtons()
        }
    }
    
    @IBAction func selectPayment(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        
        if sender.currentTitle == nil {
            return
        }
        
        let payment = Model.payments[sender.currentTitle!]
        
        if payment != nil{
            self.currentPayment = payment
            updatePaymentButtons()
            
        }
    }
    
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber{
            amountLabel.text=amountLabel.text!+digit
        }
        else {
            amountLabel.text=digit
            if digit != "0" {
                userIsInTheMiddleOfTypingANumber=true
            }
        }
    }
    
    @IBAction func appendDecimalSeparator(_ sender: UIButton) {
        let comma = ","
        
        if userIsInTheMiddleOfTypingANumber{
            if amountLabel.text != nil &&  !amountLabel.text!.contains(",") {
                amountLabel.text=amountLabel.text!+comma
            }
            
        }
        else {
            amountLabel.text = "0,"
            userIsInTheMiddleOfTypingANumber = true
            
        }
        
    }
    
    @IBAction func deleteDigit(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            amountLabel.text = String(amountLabel.text![..<amountLabel.text!.index(before: amountLabel.text!.endIndex)])

        }
        if amountLabel.text == nil || amountLabel.text! == "" {
            amountLabel.text = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    
    @IBAction func focusOnCostAmount(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    private func updateConcernedPeopleButtons(){
        switch currentConcernedPeople {
        case .Single?:
            groupButton.alpha = lowAlpha
            singleButton.alpha = 1
        case .Group?:
            groupButton.alpha = 1
            singleButton.alpha = lowAlpha
        default:
            groupButton.alpha = lowAlpha
            singleButton.alpha = lowAlpha
        }
        
        
    }
    
    private func updatePaymentButtons(){
        switch currentPayment {
        case .Cash?:
            cardButton.alpha = lowAlpha
            cashButton.alpha = 1
        case .Card?:
            cardButton.alpha = 1
            cashButton.alpha = lowAlpha
        default:
            cardButton.alpha = lowAlpha
            cashButton.alpha = lowAlpha
        }
    }
    
    private func updateCategoryButtons(buttonName: String?){
        for token in categoryStackView.subviews {
            if let button = token as? UIButton {
                if (button.currentTitle == buttonName){
                    button.alpha = 1
                }
                else {
                    button.alpha = lowAlpha
                    
                }
            }
        }
    }
    
    private func updateDateButton(){
        
        if currentDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            dateButton?.setTitle( dateFormatter.string(from: currentDate!) , for: UIControlState.normal)
            dateButton?.setTitle( dateFormatter.string(from: currentDate!) , for: UIControlState.highlighted)
            
        }
        
        
    }
    
    private func updateBuyerButton(){
        if currentBuyerName != nil {
            userButton?.setTitle( currentBuyerName!, for: UIControlState.normal)
            userButton?.setTitle( currentBuyerName!, for: UIControlState.highlighted)
            
        }
        
    }
    
    
    
    func updateCurrencyButton(){
        if let currency = currentCurrency {
            currencyButton?.setTitle( currency , for: UIControlState.normal)
            currencyButton?.setTitle( currency , for: UIControlState.highlighted)        }
    }
    
    private func updateBackgroundColor() {
        
        if let currentCategory = currentCategory, let categoryInformation = Configuration.informationForCategory[currentCategory] {
            /*for button in digitsButtons {
             button.backgroundColor = categoryInformation.color
             }*/
            amountLabel.backgroundColor = categoryInformation.color
        }
    }
    
    @IBAction func ChangePerson(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        selectNextTraveler()
        updateBuyerButton()
    }
    
    func selectNextTraveler(){
        let response = trip.selectNextTraveler(currentBuyerId: currentBuyerId)
        currentBuyerId = response.id
        currentBuyerName = response.name
        currentBuyerShortName = response.shortName
    }
    
    @IBAction func ChangeCurrency(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        selectNextCurrency()
        updateCurrencyButton()
    }
    
    func selectNextCurrency(){
        let currency = trip.selectNextCurrency(currentCurrency: currentCurrency)
        currentCurrency = currency
    }
}


//UI
extension CostViewController {
    private func updateTextColor() {
        amountLabel.textColor = Configuration.costTextColor
        nameTextField.textColor = Configuration.costTextColor
        
        dateButton.setTitleColor(Configuration.costTextColor, for: UIControlState.normal)
        dateButton.setTitleColor(Configuration.costTextColor, for: UIControlState.highlighted)
        
        currencyButton.setTitleColor(Configuration.costTextColor, for: UIControlState.normal)
        currencyButton.setTitleColor(Configuration.costTextColor, for: UIControlState.highlighted)
        
        userButton.setTitleColor(Configuration.costTextColor, for: UIControlState.normal)
        userButton.setTitleColor(Configuration.costTextColor, for: UIControlState.highlighted)
        
        for button in buttons {
            button.setTitleColor(Configuration.costDigitButtonTextColor, for: UIControlState.normal)
            button.setTitleColor(Configuration.costDigitButtonTextColor, for: UIControlState.highlighted)
            button.backgroundColor = Configuration.costDigitButtonBackgroundColor
            button.titleLabel?.font = Configuration.font
        }
    }
    
    private func setRoundedCancelAndValidateButton() {
        let layer1: CAShapeLayer = CAShapeLayer()
        let path1: UIBezierPath = UIBezierPath(roundedRect: cancelButton.bounds, byRoundingCorners: UIRectCorner.bottomLeft, cornerRadii: CGSize(width: 10, height: 10))
        layer1.path = path1.cgPath
        cancelButton.layer.mask = layer1
        //cancelButton.layer.cornerRadius = 10
        
        let layer2: CAShapeLayer = CAShapeLayer()
        let path2: UIBezierPath = UIBezierPath(roundedRect: saveButton.bounds, byRoundingCorners: UIRectCorner.bottomRight, cornerRadii: CGSize(width: 10, height: 10))
        layer2.path = path2.cgPath
        saveButton.layer.mask = layer2
        //saveButton.layer.cornerRadius = 10
    }
    
    
    private func setRoundedCorners(){
        //        topView.layer.shadowColor = UIColor.red.cgColor
        //        topView.layer.shadowOffset = CGSize.init(width: CGFloat(5), height: CGFloat(5))
        //        topView.layer.shadowOpacity = 0
        //        topView.layer.shadowRadius = 0
        
        //topView.layer.cornerRadius = 10
        let layer: CAShapeLayer = CAShapeLayer()
        let size = CGSize(width: 10, height: 0)
        let path: UIBezierPath = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight, UIRectCorner.bottomLeft], cornerRadii: size )
        layer.path = path.cgPath
        topView.layer.mask = layer
        
    }
    
    private func setRoundedAmountLabel() {
        //amountLabel.layer.cornerRadius = 10
        
        
        let layer: CAShapeLayer = CAShapeLayer()
        
        let size = CGSize(width: 10, height: 0)
        let path: UIBezierPath = UIBezierPath(roundedRect: amountLabel.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: size )
        layer.path = path.cgPath
        
        amountLabel.layer.mask = layer
        
    }
}

