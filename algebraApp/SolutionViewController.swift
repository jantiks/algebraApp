//
//  SolutionViewController.swift
//  algebraApp
//
//  Created by Tigran on 1/11/21.
//  Copyright © 2021 Tigran. All rights reserved.
//

import UIKit

class SolutionViewController: UIViewController {
    
    let variable = "x"
    var equation = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        solve(equation: equation)
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
        } else if variable.count == 2 && variable[0] == "-" {
            return -1
        } else if variable.count == 2 && variable[0] == "+" {
            return 1
        }
        
        for i in 0..<variable.count {
            if let coef = Int(String(variable[i])) {
                coefficient += String(coef)
            }
        }
        if variable[0] == "-" {
            return -Int(coefficient)!
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
        //shows equation
        print("this is your equation \(equation)")
        let leftHandSide = String(equation.split(separator: "=")[0])
        let rightHandSide = String(equation.split(separator: "=")[1])
        
        //spliting two sides of equation
        var leftHandSideArr = split(equation: leftHandSide)
        var rightHandSideArr = split(equation: rightHandSide)
        
        //collectting constants and variables
        let result = collectLikeTerms(leftHandSide: leftHandSideArr, rightHandSide: rightHandSideArr)
        leftHandSideArr = result[0]
        rightHandSideArr = result[1]
        print("step:1 lets connect like varibales in leftHandSIde and constants in the other")
        print(getSolution(leftHandSide: leftHandSideArr, rightHandSide: rightHandSideArr))
        
        //simplifing left and right sides
        let leftSolution = simplifyExpression(expression: leftHandSideArr)
        let rightSolution = simplifyConstants(constants: rightHandSideArr)
        print("step2: lets simplify the expression")
        print(getSolution(leftHandSide: [leftSolution], rightHandSide: [rightSolution]))
        
        //finding variable
        let coef = getCoefficient(variable: leftSolution)
        if coef != 1 {
            print("step3: divide both parts by \(coef)")
            let rightSol = (Float(rightSolution)!)/Float(coef)
            print(variable + " = " + String(rightSol))
        }
        
    }
    


}
