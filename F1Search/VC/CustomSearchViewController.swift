//
//  CustomSearchViewController.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import UIKit
import DropDown
import PKHUD

class CustomSearchViewController: UIViewController {
    
    private let search = Request()
    private lazy var dataSource = GenericTableView(dataType: [Race](),
                                                   cellConfigure: { cell, race in
                                                    cell.textLabel?.text = race.resultArray.first?.fullName
                                                    cell.detailTextLabel?.text = race.raceName
                                                   },
                                                   sectionHeader: nil,
                                                   cellSelection: { [weak self] race in
                                                    guard let weakSelf = self else { return }
                                                    if let controller  = weakSelf.storyboard!.instantiateViewController(identifier: "DetailsViewController")
                                                        as? DetailsViewController {
                                                        controller.search.searchPosition = nil
                                                        if let seasonString = race.season, let season = Int(seasonString) {
                                                            controller.search.searchYear = season
                                                        }
                                                        if let url = race.url {
                                                            controller.search.detailScreenHeaderURL = url
                                                        }
                                                        if let roundString = race.round, let round = Int(roundString) {
                                                            controller.search.searchRaceRound = round
                                                        }
                                                        weakSelf.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                   })
    
    private let requestMaker: URLRequestable = URLRequestMaker()
    private let yearMenu = DropDown()
    private let positionMenu = DropDown()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearLabel: UIButton!
    @IBOutlet weak var positionLabel: UIButton!
    @IBAction func yearPickerButton(_ sender: UIButton) {
        yearMenu.show()
    }
    @IBAction func positionPickerButton(_ sender: UIButton) {
        positionMenu.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        customizeDropDowns()
        performSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        showHUD(for: .lodaing)
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if data.responseData.table.races.isEmpty {
                        showHUD(for: .emptySearchResult)
                        weakSelf.tableView.isHidden = true
                    } else {
                        showHUD(for: .success)
                        weakSelf.dataSource.data = data.responseData.table.races
                        weakSelf.tableView.reloadData()
                        weakSelf.tableView.isHidden = false
                    }
                case .failure(let error): print(error.localizedDescription)
                    showHUD(for: .urlFailure)
                }
            }
            weakSelf.search.isLoading = false
        }
    }
    private func customizeDropDowns() {
        yearLabel.setTitle("\(search.searchYear)", for: .normal)
        if let searchPosition = search.searchPosition {
            positionLabel.setTitle("\(searchPosition)", for: .normal)
        }
        yearMenu.backgroundColor = .black
        positionMenu.backgroundColor = .black
        yearMenu.textColor = .white
        positionMenu.textColor = .white
        yearMenu.anchorView = yearLabel
        positionMenu.anchorView = positionLabel
        yearMenu.dataSource = search.yearArr
        positionMenu.dataSource = search.positionArr
        yearMenu.selectionAction = {[weak self] (_: Int, item: String) in
            self?.yearLabel.setTitle(item, for: .normal)
            self?.search.searchYear = Int(item)!
            self?.performSearch()
        }
        positionMenu.selectionAction = {[weak self] (_: Int, item: String) in
            self?.positionLabel.setTitle(item, for: .normal)
            self?.search.searchPosition = Int(item)!
            self?.performSearch()
        }
    }
}
