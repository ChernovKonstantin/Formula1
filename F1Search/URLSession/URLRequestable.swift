//
//  URLRequester.swift
//  F1Search
//
//  Created by Константин Чернов on 27.01.2021.
//

import Foundation

protocol URLRequestable {
    func performSearchFor<Response: Decodable>(request: Request,
                                               completion: @escaping (Result<Response, RequestError>) -> Void)
}
