//
//  RequestErrors.swift
//  F1Search
//
//  Created by Константин Чернов on 27.01.2021.
//

import Foundation

enum RequestError: Error {
    case jsonParseError(Error)
    case invalidRequestError(Error)
    case invalidDataError
}
