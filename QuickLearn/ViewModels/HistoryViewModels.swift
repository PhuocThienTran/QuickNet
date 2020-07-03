//
//  HistoryViewModels.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

struct HistoryViewModelHistory {
    
    private var historyModel: AppHistoryModel
    
    init() {
        historyModel = AppHistoryModel.init()
    }
    
    var historyWords: [String] {
        return historyModel.historyWords
    }
    
    var reversedHistoryWords: [String] {
        return historyModel.historyWords.reversed()
    }
    
    var reversedHistoryDictionaries: [String] {
        return historyModel.historyDictionaries.reversed()
    }
    
    var reversedHistoryUrls: [String] {
        return historyModel.historyUrls.reversed()
    }
    
}
