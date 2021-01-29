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
            case let (_, error?):
                if let error = error as NSError?, error.code == -999 {
                    return
                }
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
        if request.searchRaceRound != -1 {
            urlParts.append("\(request.searchRaceRound)")
        }
        urlParts.append("results")
        if request.searchPosition != -1 {
            urlParts.append("\(request.searchPosition)")
        }
        return URL(string: "http://ergast.com/api/f1/\(urlParts.joined(separator: "/")).json")!
    }
}
