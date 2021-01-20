//
//  ViewController.swift
//  algebraApp
//
//  Created by Tigran on 1/10/21.
//  Copyright © 2021 Tigran. All rights reserved.
//

import UIKit


class CalculateViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var quadrEqtView: UIView!
    @IBOutlet weak var quadrEqA: UITextField!
    @IBOutlet weak var quadrEqB: UITextField!
    @IBOutlet weak var quadrEqC: UITextField!
    @IBOutlet weak var quadrEqRightSide: UITextField!
    
    @IBOutlet weak var linearEqtView: UIView!
    @IBOutlet weak var linearEqA: UITextField!
    @IBOutlet weak var linearEqB: UITextField!
    @IBOutlet weak var linearEqRightSide: UITextField!
    
    
    @IBOutlet weak var equationView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var warnLabel: UILabel!
    
    let variable = "x"
    var runningNumber = ""
    
    var result = ""
    var equalIsTapped = false
    var subtractIsTapped = false
    
    var timeRemaining = 3
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        quadrEqtView.isHidden = true
        
        equationView.layer.borderWidth = 2
        equationView.layer.borderColor = UIColor.darkGray.cgColor
        calculateButton.layer.cornerRadius = 4
        warnLabel.isHidden = true
        
        
    }
    
    func buttonIsTapped(button: UIButton) {
        if runningNumber.count < 27 {
            guard let text = button.titleLabel?.text else { return }
            runningNumber += text
//            equationTF.text! = runningNumber
        }
    }

    //checks if what the user enters is a valid linear equation
//    func isValidEquation() -> Bool {
////        guard let text = equationTF.text else { return false }
//        if !isNotEmpty(text) {
//            return false
//        } else {
//            if !hasEqualSign(text) {
//                return false
//            }
//        }
//        if !hasVariable(text) {
//            return false
//        }
//
//        if !bracketsAreClosed(text) {
//            return false
//        }
//
//        return true
//    }
    // checks if equation has variable
    func hasVariable(_ equation: String) -> Bool {
        if equation.contains(variable) {
            return true
        }
        showWarnLabel("Your equation doesn't have variable")
        return false
    }
    
    //checks if equation is empty
    func isNotEmpty(_ equation: String) -> Bool {
        if !equation.isEmpty {
            return true
        }
        showWarnLabel("Your equation is empty")
        return false
    }
    // checks if brackets are closed
    func bracketsAreClosed(_ equation: String) -> Bool {
        return true
    }
    
    //  cheks if equation has equal sign
    func hasEqualSign(_ equation: String) -> Bool {
        if equation.count > 2 {
            for i in 1..<(equation.count - 1) {
                if equation[i] == "=" {
                    return true
                }
            }
        }
        
        showWarnLabel("Your equation doesn't have '=' sign")
        return false
        
    }
    
    func showWarnLabel(_ text: String) {
        warnLabel.isHidden = false
        warnLabel.text = text
        hideWarnLabel()
    }
    
    func hideWarnLabel() {
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
            [weak self] timer in
            self?.warnLabel.isHidden = true
        }
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            linearEqtView.isHidden = false
            quadrEqtView.isHidden = true
        } else {
            linearEqtView.isHidden = true
            quadrEqtView.isHidden = false
        }
    }
    
    @IBAction func calculateTapped(_ sender: UIButton) {
        
//        if isValidEquation() {
//            guard let svc = storyboard?.instantiateViewController(identifier: "solve") as? SolutionViewController else { return }
////            svc.equation = equationTF.text!
//            navigationController?.pushViewController(svc, animated: true)
//        }
        
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        if runningNumber.count < 28 {
            runningNumber += "\(sender.tag)"
            
//            equationTF.text! = runningNumber
            
            
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
//            equationTF.text! = runningNumber
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
