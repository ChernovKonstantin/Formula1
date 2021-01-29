//
//  RaceResultsArray.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class RaceResult: Codable {
    var number = ""
    var driver = Driver()
    var timeResult: RaceTime?

    enum CodingKeys: String, CodingKey {
        case driver = "Driver"
        case timeResult = "Time"
        case number
    }

    var fullName: String {
        return driver.givenName + " " + driver.familyName + " " + number
    }
}
