//
//  ResponseArray.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class Response: Codable {
    var limit = ""
    var total = ""
    var offset = ""
    var table = SeasonRaces()

    enum CodingKeys: String, CodingKey {
        case table = "RaceTable"
        case limit, total, offset
    }
}
