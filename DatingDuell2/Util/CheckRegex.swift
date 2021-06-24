//
//  CheckRegex.swift
//  DatingDuell
//
//  Created by tk on 02.06.21.
//

//Basic function to check if a string contains any of specific values

import Foundation

class CheckRegex {
    static  func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
