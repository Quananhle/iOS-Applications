//
//  ViewController.swift
//  Tip
//
//  Created by Ashley Le on 12/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit

//class ViewController: UIViewController, UITextFieldDelegate {
class ViewController: UIViewController{
    
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var partyControl: UISegmentedControl!
    @IBOutlet weak var partyNumberTextField: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipCustomSlider: UISlider!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipAmountSeparateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPaidLabel: UILabel!
    @IBOutlet weak var totalSeparateLabel: UILabel!
    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    @IBOutlet weak var splitBillLabel: UILabel!
    @IBOutlet weak var splitAmountLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var remainingAmountLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    @IBOutlet weak var totalTipAmount: UILabel!
    
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    
    var bill = 0.0, sliderTip = 0.0, tipAmount = 0.0,
    tipPercentage = 0.0, total = 0.0, splitBill = 0.0,
    remainingAmount = 0.0, partySize = 0.0, totalTip = 0.0
    var tipAmountSeparate = 0.0, totalPaidSeperate = 0.0
    let tipPercentages = [0.15, 0.18, 0.2, 0.0]
    var paidCount = 0, undoCount = 0
    
    var results: [[Double]] = Array()
    var uniqueResults: Set<Array<Double>> = Set()
    var undoMngr = UndoManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Tip Calculator"
        billAmountTextField.backgroundColor = UIColor(red: 238.0/255.0, green: 235.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        partyNumberTextField.isUserInteractionEnabled = false
        partyNumberTextField.backgroundColor = UIColor(red: 47.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        paidButton.isUserInteractionEnabled = false
        paidButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        undoButton.isUserInteractionEnabled = false
        undoButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        partySize = Double(partyNumberTextField.text!) ?? 0.0
        //get initial bill amount and calculate tips
        sliderTip = Double(tipCustomSlider.value)
        bill = Double(billAmountTextField.text!) ?? 0
        //if 'Custom' is selected
        if tipControl.selectedSegmentIndex == 3 {
            //show the slider
            tipCustomSlider.isHidden = false
            //calculate the tip amount from slider's values
            tipPercentage = sliderTip / 100
            tipAmount = bill * tipPercentage
        }
        //if other segments are selected
        else {
            tipCustomSlider.value = 0
            tipCustomSlider.isHidden = true
            tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
            tipAmount = bill * tipPercentage
        }
        //calculate tip and total
        total = bill + tipAmount
        //calculate tip for paying separately
        splitBill = total / partySize
        tipAmountSeparate = splitBill - (bill / partySize)
        // FIXME: fix tipAmountSeparte return nan when first enter party size
        if tipAmountSeparate.isNaN {
            tipAmountSeparateLabel.text = String("$0.00")
        }
        else{
            tipAmountSeparateLabel.text = String(format: "$%.2f", tipAmountSeparate)
        }
        //======================//
        //update the tip and total labels
        tipAmountLabel.text = String(format: "$%.2f", tipAmount)
        tipPercentageLabel.text = String(format: "%.2f", tipPercentage * 100) + "%"
        totalLabel.text = String(format: "$%.2f", total)
        partySize = Double(partyNumberTextField.text!) ?? 0.0
        splitBill = total / partySize
        if partySize != 0.0{
            splitAmountLabel.text = String(format: "$%.2f", splitBill) + "/pax"
        }
        else {
            splitAmountLabel.text = String(format: "$0.00")
        }
    }
    
    @IBAction func partySize(_ sender: Any) {
        partySize = Double(partyNumberTextField.text!) ?? 0.0
        splitBill = total / partySize
        //get the party size if not nil, else 0
        let isPayingSeparately = [false, true]
        //if bill amount is not 0 and separte is selected
        if true == isPayingSeparately[partyControl.selectedSegmentIndex]{
            partyNumberTextField.backgroundColor = UIColor(red: 238.0/255.0, green: 235.0/255.0, blue: 217.0/255.0, alpha: 1.0)
            partyNumberTextField.isUserInteractionEnabled = true
        }
        else {
            partyNumberTextField.backgroundColor = UIColor(red: 47.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
            partyNumberTextField.text = ""
            partyNumberTextField.isUserInteractionEnabled = false
        }
        if partySize != 0 && true == isPayingSeparately[partyControl.selectedSegmentIndex]{
            totalPaidLabel.isHidden = false
            paidButton.isHidden = false
            paidButton.isUserInteractionEnabled = true
            paidButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            undoButton.isHidden = false
            splitBillLabel.isHidden = false
            splitAmountLabel.isHidden = false
            remainingLabel.isHidden = false
            remainingAmountLabel.isHidden = false
            totalTipLabel.isHidden = false
            totalTipAmount.isHidden = false
            tipAmountLabel.isHidden = true
            totalLabel.isHidden = true
            tipAmountSeparateLabel.isHidden = false
            totalSeparateLabel.isHidden = false
            
            splitAmountLabel.text = String(format: "$%.2f", splitBill) + "/pax"
        }
        else {
            totalPaidLabel.isHidden = true
            paidButton.isHidden = true
            undoButton.isHidden = true
            undoButton.isUserInteractionEnabled = false
            undoButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            splitBillLabel.isHidden = true
            splitAmountLabel.isHidden = true
            remainingLabel.isHidden = true
            remainingAmountLabel.isHidden = true
            totalTipLabel.isHidden = true
            totalTipAmount.isHidden = true
            tipAmountLabel.isHidden = false
            totalLabel.isHidden = false
            tipAmountSeparateLabel.isHidden = true
            totalSeparateLabel.isHidden = true
        }
    }
    @IBAction func paidButtonPressed(_ sender: UIButton) {
        undoCount += 1
        //Create an array of unique array of results
        let result = [tipAmountSeparate, totalPaidSeperate, splitBill, remainingAmount, totalTip]
        uniqueResults.insert(result)
        if uniqueResults.contains(result){
            results.append(result)
        }
//        //test
//        print("Set: \(uniqueResults)")
//        print("List: \(results)")
        //------------------------------------------
        let numberPeople = Int(partyNumberTextField.text!) ?? 0
        //set variable cnt is partySize once at start and not be reassigned
        if 0 == paidCount {
            paidCount = numberPeople
        }
        //set remainingAmount once at start and not be reassigned
        if 0.0 == remainingAmount{
            remainingAmount = bill
        }
        //for the first person paying the bill with tip
        if paidCount == numberPeople {
            //remaining amount based on the tip amount decided by the first paying person, presume that all people in the party pay the same tip percentage
            remainingAmount += tipAmount
            remainingAmountLabel.text = String(format: "$%.2f", bill + tipAmount) + " for " + String(numberPeople) + " ppl"
            //first payment
            remainingAmount -= splitBill
            //add up the tip amount paid by the first person to total tip amount
            totalTip += splitBill - (bill / partySize)
        }
        //for the rest of the group
        else {
            //if the next person changes the tip amount
            if remainingAmount != (splitBill * Double(paidCount)) {
                //new remaining amount is recalculated based on the new tip amount
                remainingAmount = splitBill * Double(paidCount)
                //recalculate remaining amount after each payment
                remainingAmount -= splitBill
            }
            //otherwise, if the next person keep the same tip amount
            else {
                remainingAmount -= splitBill
            }
            //add up the tip paid by the next person to total tip amount
            totalTip += splitBill - (bill / partySize)
        }
        // FIXME: totalPaidSeperate adds up if tip percentage is changed
        totalPaidSeperate += splitBill
    
        if 2 >= paidCount {
            remainingAmountLabel.text = String(format: "$%.2f", remainingAmount) + " for " + String(paidCount-1) + " pax"
        }
        else {
            remainingAmountLabel.text = String(format: "$%.2f", remainingAmount) + " for " + String(paidCount-1) + " ppl"
        }
        if remainingAmount <= 0 {
            paidButton.isUserInteractionEnabled = false
            paidButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        }
        paidCount -= 1
        if paidCount != numberPeople{
            partyNumberTextField.isUserInteractionEnabled = false
            partyNumberTextField.backgroundColor = UIColor(red: 47.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
            undoButton.isUserInteractionEnabled = true
            undoButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }
        totalSeparateLabel.text = String(format: "$%.2f", totalPaidSeperate)
        totalTipAmount.text = String(format: "$%.2f", totalTip)
    }
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        paidCount += 1
        // TODO: undo button using undoManager()
//        if self.undoMngr.canUndo {
//            self.undoMngr.undo()
//        }
//        self.undoButton.isEnabled = self.undoMngr.canUndo
        let cur = undoCount - 1
        if 1 <= undoCount {
            tipAmountSeparateLabel.text = String(format: "$%.2f", results[cur][0])
            totalSeparateLabel.text = String(format: "$%.2f", results[cur][1])
            splitAmountLabel.text = String(format: "$%.2f", results[cur][2]) + "/pax"
            if 2 >= paidCount {
                remainingAmountLabel.text = String(format: "$%.2f", results[cur][3]) + " for " + String(paidCount) + " pax"
            }
            else {
                remainingAmountLabel.text = String(format: "$%.2f", results[cur][3]) + " for " + String(paidCount) + " ppl"
            }
            totalTipAmount.text = String(format: "$%.2f", results[cur][4])
        }
        if cur == 0 {
            totalTip = 0.0
            remainingAmountLabel.text = String(format: "$%.2f", bill + tipAmount) + " for " + String(Int(partySize)) + " ppl"
            undoButton.isUserInteractionEnabled = false
            undoButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            paidButton.isUserInteractionEnabled = true
            paidButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }
        undoCount -= 1
    }
    @IBAction func clearBarButton(_ sender: Any) {
        billAmountTextField.text = ""
        bill = 0.0
        partyNumberTextField.text = ""
        partyNumberTextField.isUserInteractionEnabled = false
        partyNumberTextField.backgroundColor = UIColor(red: 47.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        partySize = 0.0
        tipControl.selectedSegmentIndex = 3
        tipCustomSlider.value = 0
        splitBill = 0.0
        tipPercentage = 0.0
        tipPercentageLabel.text = String(format: "%.2f", tipPercentage) + "%"
        tipAmountSeparate = 0.0
        tipAmountSeparateLabel.text = String(format: "$%.2f", tipAmountSeparate)
        totalPaidSeperate = 0.0
        totalSeparateLabel.text = String(format: "$%.2f", totalPaidSeperate)
        splitBill = 0.0
        splitAmountLabel.text = String(format: "$%.2f", splitBill)
        remainingAmount = 0.0
        remainingAmountLabel.text = String(format: "$%.2f", remainingAmount)
        totalTip = 0.0
        totalTipAmount.text = String(format: "$%.2f", totalTip)
        paidCount = 0
        paidButton.isUserInteractionEnabled = false
        paidButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        undoCount = 0
        undoButton.isUserInteractionEnabled = false
        undoButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        if partyControl.selectedSegmentIndex == 1{
           partyNumberTextField.isUserInteractionEnabled = true
            partyNumberTextField.backgroundColor = UIColor(red: 238.0/255.0, green: 235.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        }
    }
}
//make rounded border button
@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
