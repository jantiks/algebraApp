//
//  ViewController.swift
//  algebraApp
//
//  Created by Tigran on 1/10/21.
//  Copyright © 2021 Tigran. All rights reserved.
//

import UIKit


class CalculateViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var quadrEqtView: UIView!
    @IBOutlet private weak var quadrEqA: UITextField!
    @IBOutlet private weak var quadrEqB: UITextField!
    @IBOutlet private weak var quadrEqC: UITextField!
    @IBOutlet private weak var quadrEqRightSide: UITextField!
    
    @IBOutlet private weak var linearEqtView: UIView!
    @IBOutlet private weak var linearEqA: UITextField!
    @IBOutlet private weak var linearEqB: UITextField!
    @IBOutlet private weak var linearEqRightSide: UITextField!
    
    
    @IBOutlet private weak var equationView: UIView!
    @IBOutlet private weak var calculateButton: UIButton!
    @IBOutlet private weak var warnLabel: UILabel!
    
    var linearTfArr = [UITextField]()
    var quadrTfArr = [UITextField]()
    
    
    
    var timeRemaining = 3
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linearTfArr = [linearEqA, linearEqB, linearEqRightSide]
        quadrTfArr = [quadrEqA, quadrEqB, quadrEqC, quadrEqRightSide]
        
        quadrEqA.delegate = self
        quadrEqtView.isHidden = true
        // preventing to show up keyword
        quadrEqA.inputView = UIView()
        quadrEqB.inputView = UIView()
        quadrEqC.inputView = UIView()
        quadrEqRightSide.inputView = UIView()
        
        linearEqA.inputView = UIView()
        linearEqB.inputView = UIView()
        linearEqRightSide.inputView = UIView()
        linearEqA.becomeFirstResponder()

        equationView.layer.borderWidth = 2
        equationView.layer.borderColor = UIColor.darkGray.cgColor
        calculateButton.layer.cornerRadius = 4
        warnLabel.isHidden = true
        
        
    }
    // checks if equation is valid
    private func isValid(_ equation: String) -> Bool {
        return isNotEmpty(equation)
    }
    
    
    //checks if equation is empty
    private func isNotEmpty(_ equation: String) -> Bool {
        if !equation.isEmpty {
            return true
        }
        showWarnLabel("Your equation is empty")
        return false
    }
    //shows the warn label
    private func showWarnLabel(_ text: String) {
        warnLabel.isHidden = false
        warnLabel.text = text
        hideWarnLabel()
    }
    
    private func hideWarnLabel() {
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
            [weak self] timer in
            self?.warnLabel.isHidden = true
        }
    }
    
    private func addNumber(_ button: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            for textField in linearTfArr {
                if textField.isFirstResponder {
                    if let _ = textField.text {
                        textField.text! += (button.titleLabel?.text)!
                    } else {
                        textField.text = button.titleLabel?.text
                    }
                    
                }
            }
        } else {
            for textField in quadrTfArr {
                if textField.isFirstResponder {
                    if let _ = textField.text {
                        textField.text! += (button.titleLabel?.text)!
                    } else {
                        textField.text = button.titleLabel?.text
                    }
                    
                }
            }
        }
    }
    
    private func changeTextField() {
        if segmentedControl.selectedSegmentIndex == 0 {
            for i in 0..<linearTfArr.count - 1 {
                if linearTfArr[i].isFirstResponder {
                    linearTfArr[i+1].becomeFirstResponder()
                    break
                }
            }
        } else {
            for i in 0..<quadrTfArr.count - 1 {
                if quadrTfArr[i].isFirstResponder {
                    quadrTfArr[i+1].becomeFirstResponder()
                    break
                }
            }
        }
        
        
    }
    
    @IBAction private func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            linearEqtView.isHidden = false
            linearEqA.becomeFirstResponder()
            quadrEqtView.isHidden = true
        } else {
            linearEqtView.isHidden = true
            quadrEqA.becomeFirstResponder()
            quadrEqtView.isHidden = false
        }
    }
    @IBAction private func deleteTapped(_ sender: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            for textField in linearTfArr {
                if textField.isFirstResponder {
                    if !textField.text!.isEmpty {
                        textField.text?.removeLast()
                    }
                }
            }
        } else {
            for textField in quadrTfArr {
                if textField.isFirstResponder {
                    if !textField.text!.isEmpty {
                        textField.text?.removeLast()
                    }
                }
            }
        }
    }
    
    @IBAction private func minusTapped(_ sender: UIButton) {
        addNumber(sender)
    }
    
    @IBAction private func calculateTapped(_ sender: UIButton) {
        
        guard let svc = storyboard?.instantiateViewController(identifier: "solve") as? SolutionViewController else { return }
        if segmentedControl.selectedSegmentIndex == 0 {
            if !isValid(linearEqRightSide.text!) { return }
            svc.equation = "\(linearEqA.text!)x+\(linearEqB.text!)=\(linearEqRightSide.text!)"
        } else {
            if !isValid(quadrEqRightSide.text!) { return }
            svc.equation = "\(quadrEqA.text!)xˆ2+\(quadrEqB.text!)x+\(quadrEqC.text!)=\(quadrEqRightSide.text!)"
        }
        
        navigationController?.pushViewController(svc, animated: true)
        
    }
    
    @IBAction private func numberTapped(_ sender: UIButton) {
        addNumber(sender)
    }
    
    @IBAction private func nextTapped(_ sender: UIButton) {
        changeTextField()
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
