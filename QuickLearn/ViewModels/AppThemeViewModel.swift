//
//  AppThemeViewModel.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

struct AppThemeViewModel {
    
    private var themeModel: AppThemeModel
    
    private var light: String // Default
    private var dark: String
    
    init() {
        
        themeModel = AppThemeModel.init()
        
        light = themeModel.themes.light
        dark = themeModel.themes.dark
        
    }
    
    
    
    // MARK: - Themes
    
    var themeName: String {
        
        switch themeModel.theme {
        case dark:
            return dark
        default:
            return light
        }
        
    }
    
    var darkTheme: String {
        return dark
    }
    
    var lightTheme: String {
        return light
    }
    
    
    
    // MARK: - UIColors
    
    var label: UIColor {
        
        switch themeModel.theme {
        case dark:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
    
    var secondaryLabel: UIColor {
        
        switch themeModel.theme {
        case dark:
            return #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9607843137, alpha: 0.6)
        default:
            return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
        }
        
    }
    
    var secondarySystemGroupedBackground: UIColor {
        
        switch themeModel.theme {
        case dark:
            return #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
    }
    
    var systemGroupedBackground: UIColor {
        
        switch themeModel.theme {
        case dark:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default:
            return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        }
        
    }
    
    var systemBackground: UIColor {
        
        switch themeModel.theme {
        case dark:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
    }
    
    
    
    // MARK: - Various Types
    
    var blurStyle: UIBlurEffect.Style {
        
        switch themeModel.theme {
        case dark:
            return .dark
        default:
            return .light
        }
        
    }
    
    var keyboardAppearence: UIKeyboardAppearance {
        
        switch themeModel.theme {
        case dark:
            return .dark
        default:
            return .default
        }
        
    }
    
    var themeSwitchState: Bool {
        
        switch themeModel.theme {
        case dark:
            return true
        default:
            return false
        }
        
    }
    
}
