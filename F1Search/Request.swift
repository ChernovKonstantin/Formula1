//
//  Search.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import Foundation

class Request{
    
    // For 2020 year because 2021 has no entries
    var searchYear = String(Calendar.current.component(.year, from: Date()) - 1)
    var searchPosition = "1"
    var searchRaceRound = ""
    var detailScreenHeaderURL = ""
    var isLodaing = true
    
    lazy var positionArr: Array<String> = {
        var array = [String]()
        for i in 1...20{
            array.append(String(i))
        }
        return array
    }()
    
    lazy var yearArr: Array<String> = {
        var array = [String]()
        for i in 1950...Calendar.current.component(.year, from: Date()) - 1{
            array.append(String(i))
        }
        array.reverse()
        return array
    }()
}
