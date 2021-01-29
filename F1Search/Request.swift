//
//  Search.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import Foundation

class Request {
    
    // For 2020 year because 2021 has no entries
    var searchYear = Calendar.current.component(.year, from: Date()) - 1
    var searchPosition = 1
    var searchRaceRound = -1
    var detailScreenHeaderURL = ""
    var isLoading = true
    
    lazy private(set) var positionArr: [String] = {
        var array = [String]()
        for index in 1...20 {
            array.append(String(index))
        }
        return array
    }()
    
    lazy private(set) var yearArr: [String] = {
        var array = [String]()
        for index in 1950...Calendar.current.component(.year, from: Date()) - 1 {
            array.append(String(index))
        }
        array.reverse()
        return array
    }()
}
