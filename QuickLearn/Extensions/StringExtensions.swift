//
//  StringExtensions.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import Foundation

extension String {
    
    func replace(_ characeters: [String], with: [String]) -> String {
        var selfString = self
        for index in 0..<characeters.count {
            let withIndex = characeters.count == with.count ? index : 0
            selfString = selfString.replacingOccurrences(of: characeters[index], with: with[withIndex], options: .regularExpression, range: nil)
        }
        return selfString
    }
    
    func replaceSpacesWith(_ characeter: String, removeSpacesAtEnd: Bool = true) -> String {
        var selfString = self
        if !selfString.isEmpty {
            let components = selfString.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            selfString = components.joined(separator: " ")
            selfString = removeSpacesAtEnd == true ? selfString.trimmingCharacters(in: .whitespacesAndNewlines) : selfString
            selfString = selfString.replacingOccurrences(of: " ", with: characeter, options: .regularExpression, range: nil)
        }
        return selfString
    }
    
    func websiteCompatibility(dictionary: String) -> String {
        var selfString = self
        
        // Keep german nouns capitalized
        if dictionary == "Wikiwörterbuch" {
            var selfStringWords = selfString.split(separator: " ")
            for index in 0..<selfStringWords.count {
                let firstLetter = String(selfStringWords[index].first ?? " ")
                let word = String(selfStringWords[index])
                selfStringWords[index] = firstLetter == firstLetter.uppercased() ? SubSequence(word.capitalized) : SubSequence(word.lowercased())
            }
            selfString = selfStringWords.joined(separator: " ")
        } else {
            selfString = selfString.lowercased()
        }
        
        // Replace spaces
        switch dictionary {
        case "La Conjugaison":
            selfString = selfString.replaceSpacesWith("_")
        case "Linternaute", "Collins", "Macmillan", "Treccani":
            selfString = selfString.replaceSpacesWith("-")
        default:
            selfString = selfString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Replace ’
        switch dictionary {
        case "Macmillan", "Linternaute":
            selfString = selfString.replace(["’"], with: ["-"])
        case "La Conjugaison":
            selfString = selfString.replace(["’"], with: ["--"])
        default:
            break
        }
        
        // Add url encoding
        selfString = selfString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? selfString
        
        // Add extension or subpage
        switch dictionary {
        case "La Conjugaison":
            selfString = selfString + ".php"
        case "Larousse":
            selfString = selfString + "&l=francais&culture="
        case "Sensagent":
            selfString = selfString + "/fr-fr"
        default:
            break
        }
        
        return selfString
    }
    
}
