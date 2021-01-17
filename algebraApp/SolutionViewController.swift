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
    var contentViewHeight: CGFloat = 0
    
    @IBOutlet weak var scrollContent: UIView!
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
            if (char == "+" || char == "-") && (i != 0) && (!isInsideBracket) {
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
        
        let expr = expression.split(separator: "(")
        
        let multiplier = expr[0] == "-" || expr[0] == "+" ? Int(expr[0] + "1") : Int(expr[0])
        var result = [String]()
        let exprInBracket = split(equation: getExprInBracket(String(expr[1])))
        for i in 0..<exprInBracket.count {
            if let elem = Int(exprInBracket[i]) {
                let constant: Int = (multiplier! * elem)
                result.append(String(constant))
                
            } else {
                let newCoef = getCoefficient(variable: exprInBracket[i]) * multiplier!
                result.append(String(newCoef) + variable)
            }
            
        }
        
        return result
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
            if variable[i] == "." {
                break
            }
            if let coef = Int(String(variable[i])) {
                coefficient += String(coef)
            }
        }
        if variable[0] == "-" {
            return -Int(coefficient)!
        }
        return Int(coefficient)!
    }
    // collects quadratic eqt components in same array
    func collectComponentsOfQuadraticEqt(_ leftHandSide: [String], _ rightHandSide: [String]) -> [[String]] {
        var quadr = [String]()
        var variables = [String]()
        var constants = [String]()
        
        for i in 0..<leftHandSide.count {
            let elem = leftHandSide[i]
            if let digit = Int(elem) {
                constants.append(String(digit))
            } else if (elem.contains("*") || elem.contains("/")) && !elem.contains("x") {
                constants.append(String(elem))
            } else if elem.contains("xˆ2") {
                quadr.append(elem)
            } else {
                variables.append(elem)
            }
        }
        
        for j in 0..<rightHandSide.count {
            var elem = rightHandSide[j]
            if let digit = Int(elem) {
                let const = -1 * digit
                constants.append(String(const))
            } else if (elem.contains("*") || elem.contains("/")) && !elem.contains("x") {
                if elem[0] == "+" {
                    elem.removeFirst()
                    constants.append(String("-" + elem))
                } else if elem[0] == "-" {
                    elem.removeFirst()
                    constants.append(String("+" + elem))
                }
            } else if elem.contains("xˆ2") {
                quadr.append(changeVariableSign(variable: elem))
            } else {
                variables.append(changeVariableSign(variable: elem))
            }
        }
        
        var result = [[""],[""],[""]]
        result[0] = quadr
        result[1] = variables
        result[2] = constants
        
        return result

    }
    
    //collects like terms in same array
    func collectLikeTerms (leftHandSide: [String], rightHandSide: [String]) -> [[String]] {
        var variables = [String]()
        var constants = [String]()
        for i in 0..<leftHandSide.count {
            var elem = leftHandSide[i]
            if let digit = Int(elem) {
                let const = Int(-1 * digit)
                constants.append(String(const))
            } else if (elem.contains("*") || elem.contains("/")) && !elem.contains("x") {
                if elem[0] == "+" {
                    elem.removeFirst()
                    constants.append(String("-" + elem))
                } else if elem[0] == "-" {
                    elem.removeFirst()
                    constants.append(String("+" + elem))
                }
                
            } else {
                variables.append(elem)
            }
        
        }
        
        for j in 0..<rightHandSide.count {
            let elem = rightHandSide[j]
            if let digit = Int(elem) {
                let const = Int(digit)
                constants.append(String(const))
            } else if (elem.contains("*") || elem.contains("/")) && !elem.contains("x") {
                constants.append(String(elem))
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
    func simplifyQuadrExpression(expression: [String]) -> String {
        var coeficiant = 0
        for i in 0..<expression.count {
            let comp = expression[i]
            if comp.contains("xˆ2") && (!comp.contains("*") || !(comp.contains("/"))) {
                var coef = ""
                for j in 0..<comp.count {
                    if comp[j] == "x" {
                        break
                    }
                    coef += String(comp[j])
                }
                coeficiant += Int(coef)!
                
            }
        }
        if coeficiant == 1 {
            return "xˆ2"
        } else if coeficiant == -1 {
            return "-xˆ2"
        }
        
        return String(coeficiant) + "xˆ2"
    }
    
    //simplifies variables
    func simplifyExpression(expression: [String]) -> String {
        var coefficient: Double = 0

        for i in expression {
            if i.contains("*") {
                var coef = 1
                let components = i.split(separator: "*").map({ (substring) in
                    return String(substring)
                })
                for j in 0..<components.count {
                    if let digit = Int(components[j]){
                        coef *= digit
                    } else {
                        let variableCoef = getCoefficient(variable: components[j])
                        coef *= variableCoef
                    }
                }
                coefficient += Double(coef)
            } else if i.contains("/")  {
                var coef: Double = 1
                let components = i.split(separator: "/").map({ (substring) in
                    return String(substring)
                })
                for j in 0..<components.count {
                    if let digit = Int(components[j]){
                        if j == 0 {
                            coef = Double(digit)
                        } else {
                            coef /= Double(digit)
                        }
                    } else {
                        let variableCoef = getCoefficient(variable: components[j])
                        if j == 0 {
                            coef = Double(variableCoef)
                        } else {
                            coef /= Double(variableCoef)
                        }
                        
                        
                    }
                }
                coefficient += Double(coef)
            } else {
                coefficient += Double(getCoefficient(variable: i))
            
            }
            

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
        var constSum: Double = 0
        for number in constants {
            if let digit = Double(number) {
                constSum += digit
            } else if number.contains("*") {
                var result = 1
                let components = number.split(separator: "*")
                for comps in components {
                    if let digit = Int(String(comps)) {
                        result *= digit
                    }
                }
                constSum += Double(result)
            } else if number.contains("/") {
                let components = number.split(separator: "/")
                var result = Double(components[0])
                for i in 1..<components.count {
                    if let digit = Double(String(components[i])) {
                         result! /= digit
                    }
                   
                }
                constSum += result!
            }
            
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
    
    
    func displaySteps(labelText: String , equation: String) {
        let label = UILabel()
        let equationLabel = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.frame.size.width = self.scrollContent.frame.width - 10
        label.frame.size.height = 100
        label.text = labelText
        label.font = label.font.withSize(19)
        
        equationLabel.translatesAutoresizingMaskIntoConstraints = false
        equationLabel.textAlignment = .left
        equationLabel.frame.size.width = self.scrollContent.frame.width - 10
        equationLabel.text = equation
        equationLabel.font = equationLabel.font.withSize(17)
        
        scrollContent.addSubview(equationLabel)
        scrollContent.addSubview(label)
        
        NSLayoutConstraint.activate(
            [label.topAnchor.constraint(equalTo: scrollContent.layoutMarginsGuide.topAnchor, constant: contentViewHeight),
             label.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor),
             label.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor),
            equationLabel.topAnchor.constraint(equalTo: label.layoutMarginsGuide.bottomAnchor, constant: 10)])
        
        contentViewHeight += label.frame.size.height
    }
    
    func solve(equation: String) {
        
        let leftHandSide = String(equation.split(separator: "=")[0])
        let rightHandSide = String(equation.split(separator: "=")[1])
        
        //spliting two sides of equation
        var leftHandSideArr = split(equation: leftHandSide)
        var rightHandSideArr = split(equation: rightHandSide)
        
        if containsBracket(expression: equation) {
            if containsBracket(expression: leftHandSide)  {
                leftHandSideArr = openBracket(equationComponents: leftHandSideArr)
            }
            if containsBracket(expression: rightHandSide) {
                rightHandSideArr = openBracket(equationComponents: rightHandSideArr)
            }
        }
        
        
        if equation.contains(variable + "ˆ2") {
            let result = collectComponentsOfQuadraticEqt(leftHandSideArr, rightHandSideArr)
            let quadrVars = result[0]
            let variables = result[1]
            let constants = result[2]
            
            var quadrVarsSimpl = simplifyQuadrExpression(expression: quadrVars)
            var variablesSimpl = simplifyExpression(expression: variables)
            var constantsSimpl = simplifyConstants(constants: constants)

            print(quadrVarsSimpl , variablesSimpl, constantsSimpl)
//            let x1 = findSolutionOfQuadraticEqt()
//            let x2 = findSolutionOfQuadraticEqt()
            
            
        } else {
            //collectting constants and variables
            let result = collectLikeTerms(leftHandSide: leftHandSideArr, rightHandSide: rightHandSideArr)
            leftHandSideArr = result[0]
            rightHandSideArr = result[1]
            displaySteps(labelText: "step1: lets connect like varibales in leftHandSIde and constants in the other", equation: getSolution(leftHandSide: leftHandSideArr, rightHandSide: rightHandSideArr))
            
            
            //simplifing left and right sides
            let leftSolution = simplifyExpression(expression: leftHandSideArr)
            let rightSolution = simplifyConstants(constants: rightHandSideArr)
            displaySteps(labelText: "step2: lets simplify the expression", equation: getSolution(leftHandSide: [leftSolution], rightHandSide: [rightSolution]))
            
            //finding variable
            let coef = getCoefficient(variable: leftSolution)
            if coef != 1 {
                let rightSol = (Float(rightSolution)!)/Float(coef)
                displaySteps(labelText: "step3: divide both parts by \(coef)", equation: variable + " = " + String(rightSol))
            }
        }
        
        
    }
    


}
