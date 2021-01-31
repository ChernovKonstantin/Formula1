//
//  HandlerTableViews.swift
//  F1Search
//
//  Created by Константин Чернов on 29.01.2021.
//

import Foundation
import UIKit

class DataSourceHandler: NSObject, UITableViewDataSource {
    
    var races = [Race]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 100, 101: return races.count
        case 102: return races.first?.resultArray.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch tableView.tag {
        case 100, 101:
            cell.textLabel?.text = races[indexPath.row].resultArray.first?.fullName
            cell.detailTextLabel?.text = races[indexPath.row].raceName
        case 102:
            cell.textLabel?.text = races.first?.resultArray[indexPath.row].fullName
            cell.detailTextLabel?.text = races.first?.resultArray[indexPath.row].timeResult?.time ?? "No race time"
        default: return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !races.isEmpty {
            switch tableView.tag {
            case 100: return "Winners in  \(races.first!.season) season"
            case 102: return "Results:"
            default: return nil
            }
        }
        return nil
    }
}
