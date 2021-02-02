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
    
    private let search = Request()
    private let requestMaker: URLRequestable = URLRequestMaker()
    
    private lazy var dataSource = GenericTableView(dataType: [Race](),
                                           cellConfigure: {cell, race in
                                            cell.textLabel?.text = race.resultArray.first?.fullName
                                            cell.detailTextLabel?.text = race.raceName
                                           },
                                           sectionHeader: {
                                            return "Winners in \(self.search.searchYear) season"
                                           },
                                           cellSelection: { [weak self] race in
                                            guard let weakSelf = self else { return }
                                            if let controller  = weakSelf.storyboard!.instantiateViewController(identifier: "DetailsViewController")
                                                as? DetailsViewController {
                                                controller.search.searchPosition = nil
                                                if let url = race.url {
                                                    controller.search.detailScreenHeaderURL = url
                                                }
                                                if let roundString = race.round, let round = Int(roundString) {
                                                    controller.search.searchRaceRound = round
                                                }
                                                weakSelf.navigationController?.pushViewController(controller, animated: true)
                                            }
                                           })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = dataSource
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
    
    private func performSearch() {
        search.isLoading = true
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    weakSelf.dataSource.data = data.responseData.table.races
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
