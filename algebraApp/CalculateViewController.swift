//
//  ViewController.swift
//  algebraApp
//
//  Created by Tigran on 1/10/21.
//  Copyright © 2021 Tigran. All rights reserved.
//

import UIKit

enum Operation: String {
    case Add = "+"
    case Subtract = "-"
    case Multiply = "*"
    case Divide = "/"
    case Null = "Null"
}

class CalculateViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var equationView: UIView!
    @IBOutlet weak var equationTF: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    var runningNumber = ""
    var currentNumber = ""
    var rightHandSide = [String]()
    var leftHandSide = [String]()
    var result = ""
    var currentOperation: Operation = .Null
    var equalIsTapped = false
    var subtractIsTapped = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        equationView.layer.borderWidth = 2
        equationView.layer.borderColor = UIColor.darkGray.cgColor
        calculateButton.layer.cornerRadius = 4
        
    }
    
    
    
    func buttonIsTapped(button: UIButton) {
        if runningNumber.count < 27 {
            guard let text = button.titleLabel?.text else { return }
            runningNumber += text
            equationTF.text! = runningNumber
        }
    }
    
    // sorts numbers to leftHandSide and rightHandSide
//    func sortNumbers() {
//        if !currentNumber.isEmpty {
//            if equalIsTapped {
//                if subtractIsTapped {
//                    rightHandSide.append("-\(currentNumber)")
//                    subtractIsTapped = false
//                } else {
//                    rightHandSide.append("\(currentNumber)")
//                }
//
//            } else {
//                if subtractIsTapped {
//                    leftHandSide.append("-\(currentNumber)")
//                    subtractIsTapped = false
//                } else {
//                    leftHandSide.append("\(currentNumber)")
//                }
//            }
//            print(leftHandSide,rightHandSide)
//            currentNumber = ""
//        }
//
//    }
    
    func containsBracket(expression: String) -> Bool {
        return expression.contains("(")
    }
    
    // splits equation into components
    func split(equation: String) -> [String] {
        var expression = ""
        var splitedEquation = [String]()
        var isInsideBracket = false
        
        for i in 0..<(equation.count) {
            let char = String(equation[i])
            if char == "+" || char == "-" && i != 0 && !isInsideBracket {
                splitedEquation.append(expression)
                expression = char
            } else {
                expression += char
            }
            if  char == "(" {
                isInsideBracket = true
            } else if char == ")" {
                isInsideBracket = false
            }
        }
        splitedEquation.append(expression)
        return splitedEquation
    }
    //removes and evaluates components with bracket.
    func openBracket(equationComponents: [String]) -> [String]{
        var eqtComponents = [String]()
        for i in equationComponents {
            if containsBracket(expression: i) {
                eqtComponents.append(contentsOf: expand(i))
            } else {
                eqtComponents.append(i)
            }
        }
        return eqtComponents
    }
    
    func getExprInBracket(_ expr: String) -> String {
        var exprInBracket = ""
        for i in 0..<(expr.count - 1) {
            exprInBracket += String(expr[i])
        }
        return exprInBracket
    }
    
    //expands expretion if it contains brackets
    func expand(_ expression: String) -> [String] {
        //TODO: write the function
        return ["A"]
    }
    
    //changes variable sign
    func changeVariableSign(variable: String) -> String {
        let char = variable[0]
        if char == "+" {
            return variable.replacingOccurrences(of: "+", with: "-")
        } else if char == "-" {
            return variable.replacingOccurrences(of: "-", with: "+")
        } else {
            return "-" + variable
        }
    }
    
    //gets coefficient of variable
    func getCoefficient(variable: String) -> Int {
        var coefficient = ""
        if variable.count == 1 {
            return 1
        } else if variable.count == 1 && variable[0] == "-" {
            return -1
        }
        
        for i in 0..<variable.count {
            if let _ = Int(String(variable[i])) {
                coefficient += String(variable[i])
            }
        }
        if variable[0] == "-" {
            return Int("-" + coefficient)!
        }
        return Int(coefficient)!
    }
    
    //collects like terms in same array
    func collectLikeTerms (leftHandSide: [String], rightHandSide: [String]) -> [String] {
        return ["a"]
    }
    
    func solve() {
        print(runningNumber)
        print(split(equation: runningNumber))
    }
    
    
    @IBAction func calculateTapped(_ sender: UIButton) {
        
        if !equationTF.text!.isEmpty {
            solve()
            if !currentNumber.isEmpty {
                rightHandSide.append(currentNumber)
            }
            guard let svc = storyboard?.instantiateViewController(identifier: "solve") else { return }
            navigationController?.pushViewController(svc, animated: true)
        } else {
            let ac = UIAlertController(title: "Empty equation", message: "Type an equation", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        if runningNumber.count < 28 {
            currentNumber += "\(sender.tag)"
            runningNumber += "\(sender.tag)"
            
            equationTF.text! = runningNumber
            
            
        }
        
    }
    
    @IBAction func openBracketTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func closeBracketTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func powerTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func squareRootTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func xTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func dotTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func delTapped(_ sender: UIButton) {
        if runningNumber.count > 0 {
            let char = runningNumber.removeLast()
            if char == "=" {
                equalIsTapped = false
            }
            equationTF.text! = runningNumber
        }
    }
    
    @IBAction func equalTapped(_ sender: UIButton) {
        if !equalIsTapped {
            buttonIsTapped(button: sender)
            equalIsTapped = true
        }
    }
    @IBAction func divideTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
    }
    @IBAction func multiplyTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)

    }
    @IBAction func subtractTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)
        subtractIsTapped = true


    }
    @IBAction func addTapped(_ sender: UIButton) {
        buttonIsTapped(button: sender)

        
    }
    
    

}

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

}
