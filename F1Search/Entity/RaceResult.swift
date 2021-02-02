//
//  RaceResultsArray.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class RaceResult: Codable {
    var number: String?
    var driver = Driver()
    var timeResult: RaceTime?
    
    enum CodingKeys: String, CodingKey {
        case driver = "Driver"
        case timeResult = "Time"
        case number
    }
    
    var fullName: String {
        var name: [String] = [""]
        if let givenName = driver.givenName {
            name.append(givenName)
        }
        
        if let familyName = driver.familyName {
            name.append(familyName)
        }
        
        if let number = number {
            name.append(number)
        }
        return name.joined(separator: " ")
    }
}
