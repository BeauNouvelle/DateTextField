//
//  DateTextField.swift
//  DateTextField
//
//  Created by Beau Nouvelle on 19/3/17.
//  Copyright © 2017 Beau Nouvelle. All rights reserved.
//

import UIKit
import Foundation

protocol DateTextFieldDelegate: class {
    func dateDidChange(dateTextField: DateTextField)
}

public class DateTextField: UITextField {
    
    public enum format: String {
        case monthYear = "MM'$'yyyy"
        case dayMonthYear = "dd'*'MM'$'yyyy"
        case monthDayYear = "MM'$'dd'*'yyyy"
    }
    
    // MARK: - Properties
    private let digitOnlyRegex = try! NSRegularExpression(pattern: "[^0-9]+", options: NSRegularExpression.Options(rawValue: 0))
    private let dateFormatter = DateFormatter()
    
    public var dateFormat = format.dayMonthYear
    public var separator: String = " / "
    weak var customDelegate: DateTextFieldDelegate?
    
    /// Parses the `text` property into a `Date` and returns if successful.
    public var date: Date? {
        get {
            let format = dateFormat.rawValue.replacingOccurrences(of: "$", with: separator).replacingOccurrences(of: "*", with: separator)
            dateFormatter.dateFormat = format
            return dateFormatter.date(from: text ?? "")
        }
        set {
            if newValue != nil {
                let format = dateFormat.rawValue.replacingOccurrences(of: "$", with: separator).replacingOccurrences(of: "*", with: separator)
                dateFormatter.dateFormat = format
                text = dateFormatter.string(from: newValue!)
            } else {
                text = nil
            }
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        super.delegate = self
        keyboardType = .numberPad
        autocorrectionType = .no
    }
    
    func numberOnlyString(with string: String) -> String {
        return digitOnlyRegex.stringByReplacingMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count), withTemplate: "")
    }
    
}

// MARK: - UITextFieldDelegate
extension DateTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count == 0 {
            customDelegate?.dateDidChange(dateTextField: self)
            return true
        }
        
        guard let swiftRange = textField.text?.getRange(from: range) else { return false }
        guard let replacedString = textField.text?.replacingCharacters(in: swiftRange, with: string) else { return false }
        
        // Because you never know what people will paste in here, and some emoji have numbers present.
        let emojiFreeString = replacedString.stringByRemovingEmoji()
        let numbersOnly = numberOnlyString(with: emojiFreeString)
        
        switch dateFormat {
        case .monthYear:
            guard numbersOnly.characters.count <= 6 else { return false }
            let splitString = split(string: numbersOnly, format: [2,4])
            textField.text = final(day: "", month: splitString.count > 0 ? splitString[0] : "", year: splitString.count > 1 ? splitString[1] : "")
        case .dayMonthYear:
            guard numbersOnly.characters.count <= 8 else { return false }
            let splitString = split(string: numbersOnly, format: [2,2,4])
            textField.text = final(day: splitString.count > 0 ? splitString[0] : "", month: splitString.count > 1 ? splitString[1] : "", year: splitString.count > 2 ? splitString[2] : "")
        case .monthDayYear:
            guard numbersOnly.characters.count <= 8 else { return false }
            let splitString = split(string: numbersOnly, format: [2,2,4])
            textField.text = final(day: splitString.count > 1 ? splitString[1] : "", month: splitString.count > 0 ? splitString[0] : "", year: splitString.count > 2 ? splitString[2] : "")
        }
        customDelegate?.dateDidChange(dateTextField: self)
        return false
    }
    
    func split(string: String, format: [Int]) -> [String] {
        
        var mutableString = string
        var splitString = [String]()
        
        for item in format {
            if mutableString.characters.count == 0 {
                break
            }
            if mutableString.characters.count >= item {
                let index = string.index(mutableString.startIndex, offsetBy: item)
                splitString.append(mutableString.substring(to: index))
                mutableString.removeSubrange(Range(uncheckedBounds: (mutableString.startIndex, index)))
            } else {
                splitString.append(mutableString)
                mutableString.removeSubrange(Range(uncheckedBounds: (mutableString.startIndex, mutableString.endIndex)))
            }
        }
        
        return splitString
    }
    
    func final(day: String, month: String, year: String) -> String {
        
        var dateString = dateFormat.rawValue
        dateString = dateString.replacingOccurrences(of: "dd", with: day)
        dateString = dateString.replacingOccurrences(of: "MM", with: month)
        dateString = dateString.replacingOccurrences(of: "yyyy", with: year)
        
        if day.characters.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "*", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "*", with: "")
        }
        if month.characters.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "$", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "$", with: "")
        }
        
        return dateString.replacingOccurrences(of: "'", with: "")
    }
    
}

// MARK: - String Extension
extension String {
    
    fileprivate func getRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    fileprivate func stringByRemovingEmoji() -> String {
        return String(self.characters.filter { !$0.isEmoji() })
    }
    
}

// MARK: - Character Extension
extension Character {
    fileprivate func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}

