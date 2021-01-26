//
//  RacesArray.swift
//  F1Search
//
//  Created by Константин Чернов on 22.01.2021.
//

import Foundation

class RacesArray: Codable{
    var races = [Race]()
    
    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}
