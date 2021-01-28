//
//  URLRequestMaker.swift
//  F1Search
//
//  Created by Константин Чернов on 27.01.2021.
//

import Foundation

class URLRequestMaker: URLRequestable{
    
    private var dataTask: URLSessionDataTask?
    private let decoder = JSONDecoder()
    
    func performSearchFor<Response>(request: Request, completion: @escaping (Result<Response, RequestError>) -> ()) where Response : Decodable {
        dataTask?.cancel()
        let url = setUrlFor(request: request)
        print(url)
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error as NSError?, error.code == -999 {
                return
            }
            guard let weakSelf = self else { return }
            switch (data, error){
            case let (_, error?):
                completion(.failure(.invalidRequestError(error)))
            case let (data?, .none):
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
    
    private func setUrlFor (request: Request) -> URL{
        var positionFinished = ""
        var kind = ""
        if !request.searchPosition.isEmpty{
            positionFinished = "/" + request.searchPosition
        }
        if !request.searchRaceRound.isEmpty{
            kind = "/" + request.searchRaceRound
        }
        let date = request.searchYear
        return URL(string: "http://ergast.com/api/f1/\(date)\(kind)/results\(positionFinished).json")!
    }
}
