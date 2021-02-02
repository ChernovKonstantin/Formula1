//
//  DetailsViewController.swift
//  F1Search
//
//  Created by Константин Чернов on 20.01.2021.
//

import UIKit
import PKHUD

class DetailsViewController: UIViewController {
    
    private lazy var dataSource = GenericTableView(dataType: [RaceResult](),
                                           cellConfigure: {cell, race in
                                            cell.textLabel?.text = race.fullName
                                            cell.detailTextLabel?.text = race.timeResult?.time ?? "No race time"
                                           },
                                           sectionHeader: {
                                            return "Results:"
                                           },
                                           cellSelection: { race in
                                            if let url = URL(string: (race.driver.url)!) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
                                           })
    
    let search = Request()
    private let requestMaker: URLRequestable = URLRequestMaker()
    
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var headerDetailtext: UILabel!
    @IBAction func showWikiForRace(_ sender: UIControl) {
        if let urlString = search.detailScreenHeaderURL, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        performSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if search.isLoading { showHUD(for: .lodaing) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    private func performSearch() {
        search.isLoading = true
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    weakSelf.dataSource.data = (data.responseData.table.races.first?.resultArray)!
                    showHUD(for: .success)
                    weakSelf.updateLabels(for: data.responseData.table.races.first!)
                    weakSelf.tableView.reloadData()
                    
                case .failure(let error): print(error.localizedDescription)
                    showHUD(for: .urlFailure)
                }
            }
            weakSelf.search.isLoading = false
        }
    }
    
    private func updateLabels(for race: Race) {
        if let raceName = race.raceName, let date = race.date,
           let round = race.round {
            headerText.text = "\(search.searchYear)" + " - " + round
            headerDetailtext.text = raceName + "  " + date
        }
    }
}
