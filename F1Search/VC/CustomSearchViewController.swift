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
    
    var races = [Race]()
    let search = Request()
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
        tableView.dataSource = self
        customizeDropDowns()
        performSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if search.isLodaing { showHUD(for: .lodaing) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        showHUD(for: .stopAnimating)
    }
    
    private func performSearch(){
        search.isLodaing = true
        showHUD(for: .lodaing)
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            switch result{
            case .success(let data): weakSelf.races = data.responseData.table.races;
                DispatchQueue.main.async {
                    guard !weakSelf.races.isEmpty else {showHUD(for: .emptySearchResult)
                        weakSelf.tableView.isHidden = true; return
                    }
                    weakSelf.tableView.isHidden = false
                    showHUD(for: .success)
                    weakSelf.tableView.reloadData()
                }
            case .failure(let error): print(error.localizedDescription)
                DispatchQueue.main.async {
                    showHUD(for: .urlFailure)
                }
            }
        }
        search.isLodaing = false
    }
    private func customizeDropDowns(){
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
        yearMenu.selectionAction = {[weak self] (index: Int, item: String) in
            self?.yearLabel.setTitle(item, for: .normal)
            self?.search.searchYear = item
            self?.performSearch()
        }
        positionMenu.selectionAction = {[weak self] (index: Int, item: String) in
            self?.positionLabel.setTitle(item, for: .normal)
            self?.search.searchPosition = item
            self?.performSearch()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        if segue.identifier == "CustomDetails"{
            let controller = segue.destination as! DetailsViewController
            controller.search.searchYear = races[index].season
            controller.search.searchPosition = ""
            controller.search.detailScreenHeaderURL = races[index].url
            controller.search.searchRaceRound = races[index].round
        }
    }
}

// MARK: - Table view delegate
extension CustomSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchCell", for: indexPath)
        cell.textLabel?.text = races[indexPath.row].resultArray.first?.fullName
        cell.detailTextLabel?.text = races[indexPath.row].raceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
