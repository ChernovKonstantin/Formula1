//
//  RaceResultsArray.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class RaceResultsArray: Codable{
    var number = ""
    var driver = DriverInfo()
    var timeResult: RaceTime?
    
    
    enum CodingKeys: String, CodingKey {
        case driver = "Driver"
        case timeResult = "Time"
        case number
    }
    
    var fullName: String{
        return driver.givenName + " " + driver.familyName + " " + number
    }
}
