//
//  Search.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import Foundation

class Search{
    
    private var dataTask: URLSessionDataTask? = nil
    // For 2020 year because 2021 has no entries
    var searchYear = String(Calendar.current.component(.year, from: Date()) - 1)
    var searchResults: [Race] = []
    var category = ""
    var headerURL = ""
    var searchPosition = "1"
    var isLodaing = true
    
    lazy var positionArr: Array<String> = {
        var array = [String]()
        for i in 1...20{
            array.append(String(i))
        }
        return array
    }()
    
    lazy var yearArr: Array<String> = {
        var array = [String]()
        for i in 1950...Calendar.current.component(.year, from: Date()) - 1{
            array.append(String(i))
        }
        array.reverse()
        return array
    }()
    
    private func setUrlFor (year: String?, position: String?, category: String) -> URL{
        var positionFinished = ""
        var kind = ""
        if let _ = position{
            positionFinished = "/" + position!
        } else if !searchPosition.isEmpty{
            positionFinished = "/" + searchPosition
        }
        if !category.isEmpty{
            kind = "/" + category
        }
        let date = year ?? searchYear
        return URL(string: "http://ergast.com/api/f1/\(date)\(kind)/results\(positionFinished).json")!
    }
    
    func performSearchFor(year: String? = nil, position: String? = nil, completion: @escaping (Bool) -> Void) {
        dataTask?.cancel()
        searchResults = []
        isLodaing = true
        let session = URLSession.shared
        let url = setUrlFor(year: year, position: position, category: self.category)
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            guard let weakSelf = self else { return }
            var success = false
            if let error = error as NSError?, error.code == -999 {
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                weakSelf.searchResults = weakSelf.parse(data: data)
                success = true
                weakSelf.isLodaing = false
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
        dataTask?.resume()
    }
    
    
    private func parse(data: Data) -> [Race] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(SearchResult.self, from:data)
            return result.responseData.table.races
        } catch {
            print("JSON Error: \(error)")
            return [] }
    }
}
