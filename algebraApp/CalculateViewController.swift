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
    
    let variable = "x"
    
    var runningNumber = ""
    var currentNumber = ""
    
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
    func collectLikeTerms (leftHandSide: [String], rightHandSide: [String]) -> [[String]] {
        var variables = [String]()
        var constants = [String]()
        
        for i in 0..<leftHandSide.count {
            let elem = leftHandSide[i]
            if let digit = Int(elem) {
                let const = Int(-1 * digit)
                constants.append(String(const))
            } else {
                variables.append(elem)
            }
        
        }
        
        for j in 0..<rightHandSide.count {
            let elem = rightHandSide[j]
            if let digit = Int(elem) {
                let const = Int(digit)
                constants.append(String(const))
            } else {
                variables.append(changeVariableSign(variable: elem))
                
            }
        }
        var result = [[""],[""]]
        result[0] = variables
        result[1] = constants
        return result
    }
    
    //merges left and right hand sides for displaying on app
    func getSolution(leftHandSide: [String], rightHandSide: [String]) -> String {
        
        var leftHandSolution = ""
        var rightHandSolution = ""
        
        for i in 0..<leftHandSide.count {
            if i == 0 {
                leftHandSolution = leftHandSide[i]
            } else {
                leftHandSolution = leftHandSolution + " " + getSolutionVar(variable: leftHandSide[i])
            }
        }
        
        for i in 0..<rightHandSide.count {
            if i == 0 {
                rightHandSolution = rightHandSide[i]
            } else {
                rightHandSolution = rightHandSolution + " " + getSolutionVar(variable: rightHandSide[i])
            }
        }
        
        return leftHandSolution + " = " + rightHandSolution
        
    }
    
    //simplifies variables
    func simplifyExpression(expression: [String]) -> String {
        var coefficient = 0
        for i in expression {
            coefficient += getCoefficient(variable: i)
        }
        
        if coefficient == 1 {
            return variable
        } else if coefficient == -1 {
            return "-" + variable
        }
        return String(coefficient) + variable
    }
    
    //simplifies constants
    func simplifyConstants(constants: [String]) -> String {
        var constSum = 0
        for i in constants {
            constSum += Int(i)!
        }
        return String(constSum)
    }
    //gets the variable and the sign in getSolution method.
    func getSolutionVar(variable: String) -> String {
        let firstChar = variable[0]
        if firstChar == "+" {
            return variable.replacingOccurrences(of: "+", with: "+ ")
        } else if firstChar == "-" {
            return variable.replacingOccurrences(of: "-", with: "- ")
        }
        return "+ " + variable
    }
    
    //checks if what the user enters is a valid linear equation
    func isValidEquation() -> Bool {
        return true
    }
    
    func solve(equation: String) {
        let leftHandSide = String(equation.split(separator: "=")[0])
        let rightHandSide = String(equation.split(separator: "=")[1])
        
        var leftHandSideArr = split(equation: leftHandSide)
        var rightHandSideArr = split(equation: rightHandSide)
        
        let result = collectLikeTerms(leftHandSide: leftHandSideArr, rightHandSide: rightHandSideArr)
        leftHandSideArr = result[0]
        rightHandSideArr = result[1]
        
        let leftSolution = simplifyExpression(expression: leftHandSideArr)
        let rightSolution = simplifyConstants(constants: rightHandSideArr)
        
        print(leftSolution , rightSolution)
        
    }
    
    
    @IBAction func calculateTapped(_ sender: UIButton) {
        
        if !equationTF.text!.isEmpty {
            solve(equation: equationTF.text!)
            
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
