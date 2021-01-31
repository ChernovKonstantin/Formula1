//
//  MainScreenViewController.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import UIKit
import PKHUD

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let search = Request()
    var dataSource = DataSourceHandler()
    let requestMaker: URLRequestable = URLRequestMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = dataSource
        performSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if search.isLoading { showHUD(for: .lodaing) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        showHUD(for: .stopAnimating)
    }
    
    func performSearch() {
        search.isLoading = true
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    weakSelf.dataSource.races = data.responseData.table.races
                    showHUD(for: .success)
                    weakSelf.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    showHUD(for: .urlFailure)
                }
            }
            weakSelf.search.isLoading = false
        }
    }
}

// MARK: - Table view delegate
extension MainScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            view.textLabel?.textColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let controller  = storyboard!.instantiateViewController(identifier: "DetailsViewController")
            as? DetailsViewController {
            controller.search.searchPosition = -1
            controller.search.detailScreenHeaderURL = dataSource.races[indexPath.row].url
            controller.search.searchRaceRound = Int(dataSource.races[indexPath.row].round) ?? -1
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
