//
//  AppThemeModel.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

struct AppThemeModel {
    
    let theme: String
    let themes: AppThemes.Type
    
    init() {
        theme = defaults.string(forKey: AppDefaults.theme) ?? "Light"
        themes = AppThemes.self
    }
    
}
