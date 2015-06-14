//
//  ViewController.swift
//  Calculator
//
//  Created by Michael Nichols on 6/9/15.
//  Copyright (c) 2015 Michael Nichols. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if display.text?.rangeOfString(".") == nil && digit == "." {
                display.text = display.text! + digit
            } else if digit != "." {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        history.text = history.text! + " " + operation + " "
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation { sqrt($0) }
        case "∏": addConstant(M_PI)
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    @IBAction func clearAll(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        operandStack = Array<Double>()
        println(operandStack)
    }
    
    @IBAction func backSpace() {
        if count(display.text!) > 1 {
            display.text = dropLast(display.text!)
        } else if count(display.text!) == 1 {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func addConstant(constant: Double) {
        displayValue = constant
        enter()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println(operandStack)
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

