//
//  GenericTableView.swift
//  F1Search
//
//  Created by Константин Чернов on 02.02.2021.
//

import Foundation
import UIKit

class GenericTableView <T>: UITableViewController {
    
    let cellIdentifier = "Cell"
    
    var data: [T]
    var cellConfigureHandler: (UITableViewCell, T) -> Void
    var sectionHeaderHandler: (() -> String)?
    var cellSelectionHandler: ((T) -> Void)?
    
    init(dataType: [T],
         cellConfigure: @escaping (_ cell: UITableViewCell, T) -> Void,
         sectionHeader: (() -> String)? = nil,
         cellSelection: ((T) -> Void)? = nil) {
        self.data = dataType
        self.cellConfigureHandler = cellConfigure
        self.sectionHeaderHandler = sectionHeader
        self.cellSelectionHandler = cellSelection
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let race = data[indexPath.row]
        cellConfigureHandler(cell, race)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !data.isEmpty, let setHeader = sectionHeaderHandler {
            return setHeader()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        if let race = cellSelectionHandler {
            race(item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            view.textLabel?.textColor = UIColor.gray
        }
    }
}
