//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Muhamed Rahman on 6/16/16.
//  Copyright © 2016 Muhamed Rahman. All rights reserved.
//

import Foundation


func logC(val: Double, forBase base: Double) -> Double {
    return log(val)/log(base)
}

class CalculatorBrain{

    private var descrip = ""
    private var internalProgram = [AnyObject]()
    private var isPartialResult = false
    private var accumulator = 0.0

    func setDescrip(text: String){
        if text != "="{
            descrip += text
            isPartialResult = true
        }
    }
    
    func getDescrip() -> String{
        return descrip
    }
    
    func getIsPartial() -> Bool{
        return isPartialResult
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand)

    }
    
    var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "sin" : Operation.UnaryOperation(sin),
        "x²": Operation.UnaryOperation({pow($0, 2)}),
        "log": Operation.UnaryOperation(log2),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "x^y" : Operation.BinaryOperation({pow($0, $1)}),
        "logx": Operation.BinaryOperation({logC($0, forBase: $1)}),
        "=" : Operation.Equals
    ]
    
    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double {
                        setOperand(operand)
                    }else if let operation = op as? String{
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
        
    var result: Double{
        get{
            return accumulator
        }
    }
        
}