//
//  Colors.swift
//  DatingDuell
//
//  Created by tk on 20.05.21.
//

import UIKit

public class Colors {
    
    static let primaryColorAsHexCode = "#9b5151"
    static let secondaryColorAsHexCode = "#e97878"
    static let tertiaryColorAsHexCode = "#f5d782"
    static let quaternaryColorAsHexCode = "#ffee93"
    
    // MARK: - Text Colors
    static let lightText = UIColor.lightText
       static let darkText = (UIColor.darkText)
     
    static let placeholderText = (UIColor.placeholderText)

       // MARK: - Label Colors
     
       static let label = (UIColor.label)
     
       static let secondaryLabel = (UIColor.secondaryLabel)
     
    static let tertiaryLabel = (UIColor.tertiaryLabel)
     
    static let quaternaryLabel = (UIColor.quaternaryLabel)

       // MARK: - Background Colors
     
    static let systemBackground = (UIColor.systemBackground)
     
    static let secondarySystemBackground = (UIColor.secondarySystemBackground)
     
    static let tertiarySystemBackground = (UIColor.tertiarySystemBackground)
       
       // MARK: - Fill Colors
     
    static let systemFill = (UIColor.systemFill)
     
    static let secondarySystemFill = (UIColor.secondarySystemFill)
     
    static let tertiarySystemFill = (UIColor.tertiarySystemFill)
     
    static let quaternarySystemFill = (UIColor.quaternarySystemFill)
       
       // MARK: - Grouped Background Colors
     
    static let systemGroupedBackground = (UIColor.systemGroupedBackground)
     
    static let secondarySystemGroupedBackground = (UIColor.secondarySystemGroupedBackground)
     
    static let tertiarySystemGroupedBackground = (UIColor.tertiarySystemGroupedBackground)
       
       // MARK: - Gray Colors
       static let systemGray = (UIColor.systemGray)
     
    static let systemGray2 = (UIColor.systemGray2)
     
    static let systemGray3 = (UIColor.systemGray3)
     
    static let systemGray4 = (UIColor.systemGray4)
     
    static let systemGray5 = (UIColor.systemGray5)
     
    static let systemGray6 = (UIColor.systemGray6)
       
       // MARK: - Other Colors
     
    static let separator = (UIColor.separator)
     
    static let opaqueSeparator = (UIColor.opaqueSeparator)
     
    static let link = (UIColor.link)
       
       // MARK: System Colors
       static let systemBlue = (UIColor.systemBlue)
       static let systemPurple = (UIColor.systemPurple)
       static let systemGreen = (UIColor.systemGreen)
       static let systemYellow = (UIColor.systemYellow)
       static let systemOrange = (UIColor.systemOrange)
       static let systemPink = (UIColor.systemPink)
       static let systemRed = (UIColor.systemRed)
       static let systemTeal = (UIColor.systemTeal)
 
    static let systemIndigo = (UIColor.systemIndigo)
    
    
    static func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }

    static func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        print(floatValue)
        return floatValue
    }
    
}
