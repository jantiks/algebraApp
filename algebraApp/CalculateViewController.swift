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

    
    
    @IBAction func calculateTapped(_ sender: UIButton) {
        
        if !equationTF.text!.isEmpty {
            guard let svc = storyboard?.instantiateViewController(identifier: "solve") as? SolutionViewController else { return }
            svc.equation = equationTF.text!
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
