//
//  UserDefaultsExtension.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func set(_ values: [Any?], forKeys: [String]) {
        if values.count == forKeys.count {
            for index in 0..<values.count {
                defaults.set(values[index], forKey: forKeys[index])
            }
        } else {
            fatalError("The number of values is not equal to the number of keys")
        }
    }
    
}
