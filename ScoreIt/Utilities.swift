//
//  Utilities.swift
//  ScoreIt
//
//  Created by Vik Denic on 10/18/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

import Foundation
import UIKit

enum Sport: String {
    case mlb
    case nfl
    case nba
}

extension UIColor {
    class func winGreen() -> UIColor {
        return UIColor(red: (9.0/255.0), green: (178.0/255.0), blue: (65.0/255.0), alpha: 1)
    }

    class func lossRed() -> UIColor {
        return UIColor(red: (243.0/255.0), green: (48.0/255.0), blue: (12.0/255.0), alpha: 1)
    }

    class func customGrayText() -> UIColor {
        return UIColor(red: (127.0/255.0), green: (127.0/255.0), blue: (127.0/255.0), alpha: 1)
    }
}

extension NSDate {
    func toGameString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd, h:mm a"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }

    func toDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }
    func toAPIString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        let localTZ = NSTimeZone.local
        formatter.timeZone = localTZ
        return formatter.string(from: self as Date)
    }
    func yesterday() -> NSDate {
        return NSCalendar.current.date(byAdding: .day, value: -1, to: self as Date)! as NSDate
    }
    func tomorrow() -> NSDate {
        return NSCalendar.current.date(byAdding: .day, value: 1, to: self as Date)! as NSDate
    }
}

extension String {
    func toDate() -> NSDate {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let est = NSTimeZone(abbreviation: "EST")
        formatter.timeZone = est as TimeZone!
        return formatter.date(from: self)! as NSDate
    }
}

extension String {
    func toHalfInning() -> String {
        if self == "B" {
            return "Bot"
        } else {
            return "Top"
        }
    }
}

extension Int {
    func toBool() -> Bool {
        if self == 0 {
            return false
        } else {
            return true
        }
    }
}
