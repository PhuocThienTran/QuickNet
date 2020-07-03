//
//  AppHistoryModel.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

struct AppHistoryModel {

    let historyWords, historyDictionaries, historyUrls: [String]
    
    init() {
        
        historyWords = defaults.array(forKey: AppDefaults.historyWords) as? [String] ?? [String]()
        historyDictionaries = defaults.array(forKey: AppDefaults.historyDictionaries) as? [String] ?? [String]()
        historyUrls = defaults.array(forKey: AppDefaults.historyUrls) as? [String] ?? [String]()
        
    }
    
}
