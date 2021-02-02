//
//  Race.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class Race: Codable {
    var url: String?
    var date: String?
    var season: String?
    var round: String?
    var raceName: String?
    var resultArray = [RaceResult]()

    enum CodingKeys: String, CodingKey {
        case resultArray = "Results"
        case raceName, round, season, date, url
    }
}
