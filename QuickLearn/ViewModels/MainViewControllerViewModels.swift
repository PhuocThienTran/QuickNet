//
//  MainViewControllerViewModels.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

struct MainViewModelHistory {
    
    private var historyModel: AppHistoryModel
    
    init() {
        historyModel = AppHistoryModel.init()
    }
    
    var firstHistoryWord: String {
        if historyModel.historyWords.count > 0 {
            return historyModel.historyWords.reversed()[0]
        }
        return ""
    }
    
    var firstHistoryDictionary: String {
        if historyModel.historyDictionaries.count > 0 {
            return historyModel.historyDictionaries.reversed()[0]
        }
        return ""
    }
    
    var firstHistoryUrl: String {
        if historyModel.historyUrls.count > 0 {
            return historyModel.historyUrls.reversed()[0]
        }
        return ""
    }
    
    var isFirstEmpty: Bool {
        if firstHistoryWord == "" || firstHistoryDictionary == "" || firstHistoryUrl == "" {
            return true
        }
        return false
    }
    
    var secondHistoryWord: String {
        if historyModel.historyWords.count > 1 {
            return historyModel.historyWords.reversed()[1]
        }
        return ""
    }
    
    var secondHistoryDictionary: String {
        if historyModel.historyDictionaries.count > 1 {
            return historyModel.historyDictionaries.reversed()[1]
        }
        return ""
    }
    
    var secondHistoryUrl: String {
        if historyModel.historyUrls.count > 1 {
            return historyModel.historyUrls.reversed()[1]
        }
        return ""
    }
    
    var isSecondEmpty: Bool {
        if secondHistoryWord == "" || secondHistoryDictionary == "" || secondHistoryUrl == "" {
            return true
        }
        return false
    }
    
}
