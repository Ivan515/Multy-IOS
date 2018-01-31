//
//  Dictionary+Extension.swift
//  Multy
//
//  Created by Alex Pro on 1/30/18.
//  Copyright © 2018 Idealnaya rabota. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func createTopIndexes(indexesDict: Array<Dictionary<String, UInt32>>) -> Dictionary<UInt32, UInt32> {
        var indexes = Dictionary<UInt32, UInt32>()
        
        for index in indexesDict {
            indexes[index["currencyid"]!] = index["topindex"]!
        }
        
        return indexes
    }
}
