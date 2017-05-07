//
//  ViewController.swift
//  DateTextField
//
//  Created by Beau Nouvelle on 19/3/17.
//  Copyright © 2017 Beau Nouvelle. All rights reserved.
//

import UIKit
import DateTextField

class ViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: DateTextField!
    @IBOutlet weak var displayDate: UILabel!
    @IBOutlet weak var formatTypeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.becomeFirstResponder()
        dateTextField.dateFormat = .monthYear
        dateTextField.separator = "-"
    }

    @IBAction func showDate(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        if dateTextField.date != nil {
            displayDate.text = formatter.string(from: dateTextField.date!)
        }
    }
    
    @IBAction func dateFormatChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            dateTextField.placeholder = "MM/YYYY"
            dateTextField.text = ""
            dateTextField.dateFormat = .monthYear
        case 1:
            dateTextField.placeholder = "DD/MM/YYYY"
            dateTextField.text = ""
            dateTextField.dateFormat = .dayMonthYear
        case 2:
            dateTextField.placeholder = "MM/DD/YYYY"
            dateTextField.text = ""
            dateTextField.dateFormat = .monthDayYear
        default:
            preconditionFailure("Selected index not handled")
        }
        
    }
}

