//
//  SearchResult.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import Foundation

class SearchResult: Codable {
    var responseData = Response()

    enum CodingKeys: String, CodingKey {
        case responseData = "MRData"
    }
}
