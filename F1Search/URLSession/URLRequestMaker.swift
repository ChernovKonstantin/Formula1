//
//  URLRequestMaker.swift
//  F1Search
//
//  Created by Константин Чернов on 27.01.2021.
//

import Foundation

class URLRequestMaker: URLRequestable {
    
    private var dataTask: URLSessionDataTask?
    private let decoder = JSONDecoder()
    
    func performSearchFor<Response: Decodable>(request: Request,
                                               completion: @escaping (Result<Response, RequestError>) -> Void) {
        dataTask?.cancel()
        let url = setUrlFor(request: request)
        print(url)
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let weakSelf = self else { return }
            switch (data, error) {
            case let (.none, error?):
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                fallthrough
            case let (_, error?):
                completion(.failure(.invalidRequestError(error)))
            case let (data?, _):
                do {
                    let decodedData = try weakSelf.decoder.decode(Response.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.jsonParseError(error)))
                }
            case (.none, .none):
                fatalError()
            }
        }
        dataTask?.resume()
    }
    
    private func setUrlFor (request: Request) -> URL {
        var urlParts: [String] = ["\(request.searchYear)"]
        if let searchRaceRound = request.searchRaceRound {
            urlParts.append("\(searchRaceRound)")
        }
        urlParts.append("results")
        if let searchPosition = request.searchPosition {
            urlParts.append("\(searchPosition)")
        }
        return URL(string: "http://ergast.com/api/f1/\(urlParts.joined(separator: "/")).json")!
    }
}
