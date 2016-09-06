//
//  ViewController.swift
//  Calculator
//
//  Created by Muhamed Rahman on 6/12/16.
//  Copyright © 2016 Muhamed Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    private var userIsTyping = false
    private var decUsed = false

    @IBOutlet weak var descrip: UILabel!
    
    
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping{
            
            if digit == "." && decUsed == true{
                return
            }else if digit == "." && decUsed == false {
                decUsed = true
            }
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
        } else {
            display.text = digit
        }
        userIsTyping = true
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    private var brain = CalculatorBrain()
    
    
    @IBAction func performOperation(sender: UIButton) {
        if userIsTyping{
            brain.setOperand(displayValue)
            brain.setDescrip(String(displayValue))
            if brain.getIsPartial(){
                descrip.text! =  brain.getDescrip() + "..."
            }
            
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle{
            brain.setDescrip(mathSymbol)
            descrip.text! =  brain.getDescrip()
            if brain.getIsPartial(){
                descrip.text! =  brain.getDescrip() + "..."
            }
            brain.performOperation(mathSymbol)
        }
        displayValue = brain.result
    }
    
    var savedProgram: CalculatorBrain.PropertyList?

    
    
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    


}

