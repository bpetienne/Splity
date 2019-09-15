//
//  Utilities.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 17/04/2018.
//  Copyright © 2018 Benoit ETIENNE. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func convertDateToStringdMMMMyyyy(_ date:Date) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return (dateFormatter.string(from: date))
    }
    
    static func convertInFrenchDateToStringdMMMMyyyy(_ date:Date) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        return (dateFormatter.string(from: date))
    }
    
    
        static func randomFont() -> String {
            let number = Int(arc4random_uniform(UInt32(Configuration.fonts.count)))
            let fontName =   Configuration.fonts[number]
            return fontName
        }
    
}



extension Date {
    
    func getDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    func getShortMonth() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func toYear() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start + 1
    }
}
    
    
extension Model {
    func deleteOldFiles() -> Bool{
        
        var success = false
        success = remove(atPath : Configuration.DocumentsDirectory.appendingPathComponent("model").path)
        return success
        
    }
    

    func remove(atPath: String) -> Bool {
        var isSuccess = false
        if FileManager.default.fileExists(atPath: atPath){
            try? FileManager.default.removeItem(atPath: atPath)
            isSuccess = !FileManager.default.fileExists(atPath: atPath)
        }
        return isSuccess
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setBottomBorder(color: UIColor)
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}



extension UIImage {
        
        func resize(withPercentage percentage: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        func resize(toWidth width: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
}



protocol NSCodableEnum {
    func int() -> Int
    init?(rawValue:Int)
    init(defaultValue:Any)
}

extension NSCoder
{
    func encodeEnum(e: Payment, forKey:String) {
        self.encode(e.int(), forKey: forKey)
    }
    
    func encodeEnum(e: Category?, forKey:String) {
        if let e=e {
            self.encode(e.int(), forKey: forKey)
        }
    }
    
    func encodeEnum(e: ConcernedPeople, forKey:String) {
        self.encode(e.int(), forKey: forKey)
    }
    
    
    func decodeEnumPayment(forKey:String) -> Payment? {
        if let t = Payment(rawValue:self.decodeInteger(forKey:forKey)) {
            return t
        } else {
            return nil
        }
    }
    
    func decodeEnumCategory(forKey:String) -> Category? {
        if let t = Category(rawValue:self.decodeInteger(forKey:forKey)) {
            return t
        } else {
            return nil
        }
    }
    
    func decodeEnumConcernedPeople(forKey:String) -> ConcernedPeople? {
        if let t = ConcernedPeople(rawValue:self.decodeInteger(forKey:forKey)) {
            return t
        } else {
            return nil
        }
    }
    
    func decodeEnum<T: NSCodableEnum>(forKey:String) -> T? {
        if let t = T(rawValue:self.decodeInteger(forKey:forKey)) {
            return t
        } else {
            return nil
        }
    }
    
}

extension Double
{
    func toStringWithSeparator() -> String
    {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        if let stringValue = formatter.string(for: self.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero)) {
            return stringValue
        }
        return ""
    }
    
    func toStringWithSeparatorInEuro() -> String
    {
        return self.toStringWithSeparator()+" €"
    }
}



