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
    
    let search = Request()
    var dataSource = DataSourceHandler()
    let requestMaker: URLRequestable = URLRequestMaker()
    let yearMenu = DropDown()
    let positionMenu = DropDown()
    
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
        tableView.delegate = self
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
                    weakSelf.dataSource.races = data.responseData.table.races
                    guard !weakSelf.dataSource.races.isEmpty else {showHUD(for: .emptySearchResult)
                        weakSelf.tableView.isHidden = true; return
                    }
                    weakSelf.tableView.isHidden = false
                    showHUD(for: .success)
                    weakSelf.tableView.reloadData()
                    
                case .failure(let error): print(error.localizedDescription)
                    showHUD(for: .urlFailure)
                }
            }
            weakSelf.search.isLoading = false
        }
    }
    private func customizeDropDowns() {
        yearLabel.setTitle("\(search.searchYear)", for: .normal)
        positionLabel.setTitle("\(search.searchPosition)", for: .normal)
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

// MARK: - Table view delegate
extension CustomSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let controller  = storyboard!.instantiateViewController(identifier: "DetailsViewController")
            as? DetailsViewController {
            controller.search.searchYear = Int(dataSource.races[indexPath.row].season) ?? 2020
            controller.search.searchPosition = -1
            controller.search.detailScreenHeaderURL = dataSource.races[indexPath.row].url
            controller.search.searchRaceRound = Int(dataSource.races[indexPath.row].round) ?? -1
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
