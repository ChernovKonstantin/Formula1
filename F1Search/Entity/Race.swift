//
//  Race.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class Race: Codable{
    var url = ""
    var date = ""
    var season = ""
    var round = ""
    var raceName = ""
    var resultArray = [RaceResultsArray]()
    
    enum CodingKeys: String, CodingKey {
        case resultArray = "Results"
        case raceName, round, season, date, url
    }
    
}
