//
//  AppSetup.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import Foundation
import SafariServices
import UIKit



// MARK: - Constants

let defaults = UserDefaults.standard



// MARK: - Protocols

protocol MainViewControllerDelegate: class {
    func backgroundBlur(isHidden: Bool)
    func delegateConfiguration()
    func delegateSetupTextField(isUserInteractionEnabled: Bool)
}



// MARK: - Enumerations

enum TypeInterfaceOrientationMask {
    case all
    case allButUpsideDown
    case portrait
    case landscape
}



// MARK: - Globally Accessed Structures

struct AppDefaults {
    
    static let dictionaryIndex = "dictionaryIndex"
    static let historyWords = "historyWords"
    static let historyDictionaries = "historyDictionaries"
    static let historyUrls = "historyUrls"
    static let language = "language"
    static let numberOfSearches = "numberOfSearches"
    static let theme = "theme"
    
}

// MARK: - Structures

struct ColorModel {
    let dark: UIColor
    let light: UIColor
}

struct AppLanguages {
    
    static let arabic = (name: "العربية", alpha2: "ar")
    static let german = (name: "Deutsche", alpha2: "de")
    static let english = (name: "English", alpha2: "en")
    static let spanish = (name: "Español", alpha2: "es")
    static let french = (name: "Français", alpha2: "fr")
    static let italian = (name: "Italiano", alpha2: "it")
    static let portuguese = (name: "Português", alpha2: "pt")
    static let languages = [arabic, german, english, spanish, french, italian, portuguese]
    
}

struct AppPalette {
    
    static let label = (light: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), dark: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    static let secondaryLabel = (light: #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6), dark: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9607843137, alpha: 0.6))
    static let secondarySystemGroupedBackground = (light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1))
    static let systemGroupedBackground = (light: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1), dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    static let systemBackground = (light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let blue = (light: #colorLiteral(red: 0.4980392157, green: 0.8980392157, blue: 1, alpha: 1), dark: #colorLiteral(red: 0.4, green: 0.8, blue: 0.8980392157, alpha: 1))
    static let green = (light: #colorLiteral(red: 0.6, green: 0.8980392157, blue: 0.6980392157, alpha: 1), dark: #colorLiteral(red: 0.4980392157, green: 0.8, blue: 0.6, alpha: 1))
    static let red = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.3176470588, alpha: 1)
    static let white = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let yellow = (light: #colorLiteral(red: 1, green: 0.8235294118, blue: 0.3254901961, alpha: 1), dark: #colorLiteral(red: 1, green: 0.7764705882, blue: 0.2745098039, alpha: 1))
    
}

struct AppProperties {
    
    static var searchData: (word: String, dictionary: String, url: String)?
    
}

struct AppThemes {
    
    static let dark = "Dark"
    static let light = "Light"
    
}
