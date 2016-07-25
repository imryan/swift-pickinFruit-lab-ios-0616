//
//  ViewController.swift
//  PickinFruit
//
//  Created by Flatiron School on 7/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fruitPicker: UIPickerView!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var win = false
    var fruitsArray = ["🍎", "🍊", "🍌", "🍐", "🍇", "🍉", "🍓", "🍒", "🍍"]
    
    // MARK: - Functions
    
    @IBAction func spin() {
        resultLabel.hidden = true
        
        let max = fruitsArray.count - 1
        
        for i in 0...2 {
            let row = Int(arc4random_uniform(UInt32(max)))
            fruitPicker.selectRow(row, inComponent: i, animated: true)
        }
        
        let delegate = fruitPicker.delegate
        var result: [String] = []
        
        for i in 0...2 {
            let row = fruitPicker.selectedRowInComponent(i)
            let value = delegate?.pickerView!(fruitPicker, titleForRow: row, forComponent: i)
            
            result.append(value!)
        }
        
        if (result[0] == result[1] && result[0] == result[2]) {
            updateResult(resultLabel, message: "Winner!")
            win = true
            
        } else {
            updateResult(resultLabel, message: "Try again!")
        }
        
        spinButton.enabled = false
    }
    
    func updateResult(label: UILabel, message: String) {
        label.alpha = 0
        label.hidden = false
        label.text = message
        
        if (message == "Winner!") {
            label.textColor = UIColor.blueColor()
        } else {
            label.textColor = UIColor.redColor()
        }
        
        UIView.animateWithDuration(0.3, animations: {
            label.alpha = 1
            }, completion: { (finished) in
                label.hidden = false
        })
        
        delay(1.0, closure: {
            UIView.animateWithDuration(0.3, animations: {
                label.alpha = 0
                }, completion: { (finished) in
                    label.hidden = true
                    self.spinButton.enabled = true
            })
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: - Fun Stats
    
    func getWinPercentage() {
        var wins = 0
        var losses = 0
        
        for _ in 1...100 {
            spin()
            
            if win {
                wins += 1
            } else {
                losses += 1
            }
        }
        
        let total = wins + losses
        let result = Double((Double(wins) / Double(total)) * 100)
        
        print("Out of 100 games, win percentage was \(result)%.")
    }
    
    // MARK: - Picker
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fruitsArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fruitsArray[row]
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mid = fruitsArray.count / 2
        
        for i in 0...2 {
            fruitPicker.selectRow(mid, inComponent: i, animated: false)
        }
        
        fruitPicker.userInteractionEnabled = false
        resultLabel.hidden = true
        
        self.fruitPicker.accessibilityLabel = Constants.FRUIT_PICKER
        self.spinButton.accessibilityLabel = Constants.SPIN_BUTTON
        
        // Stats
        // getWinPercentage()
    }
}

// MARK: Setup

extension ViewController {
    
    override func viewDidLayoutSubviews() {
        if self.spinButton.layer.cornerRadius == 0.0 {
            configureButton()
        }
    }
    
    func configureButton() {
        self.spinButton.layer.cornerRadius = 0.5 * self.spinButton.bounds.size.width
        self.spinButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.spinButton.layer.borderWidth = 4.0
        self.spinButton.clipsToBounds = true
    }
}
