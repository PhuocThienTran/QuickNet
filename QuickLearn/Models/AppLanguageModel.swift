//
//  AppLanguageModel.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

struct AppLanguageModel {
    
    let language: String
    let languages: AppLanguages.Type
    let dictionaries: AppDictionaries.Type
    
    init() {
        language = defaults.string(forKey: AppDefaults.language) ?? String(NSLocale.preferredLanguages[0].prefix(2))
        languages = AppLanguages.self
        dictionaries = AppDictionaries.self
    }
    
}
