//
//  DetailsViewController.swift
//  F1Search
//
//  Created by Константин Чернов on 20.01.2021.
//

import UIKit
import PKHUD

class DetailsViewController: UIViewController {
    
    var races = [Race]()
    let search = Request()
    let requestMaker: URLRequestable = URLRequestMaker()
    
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var headerDetailtext: UILabel!
    @IBAction func showWikiForRace(_ sender: UIControl) {
        if let url = URL(string: search.detailScreenHeaderURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func performSearch() {
        search.isLoading = true
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    weakSelf.races = data.responseData.table.races
                    showHUD(for: .success)
                    weakSelf.updateLabels()
                    weakSelf.tableView.reloadData()
                    
                case .failure(let error): print(error.localizedDescription)
                    showHUD(for: .urlFailure)
                }
            }
            weakSelf.search.isLoading = false
        }
    }
    
    private func updateLabels() {
        if let race = races.first?.raceName, let date = races.first?.date,
           let round = races.first?.round {
            headerText.text = "\(search.searchYear)" + " - " + round
            headerDetailtext.text = race + "  " + date
        }
    }
}

// MARK: - Table view delegate
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return races.first?.resultArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = races.first?.resultArray[indexPath.row].fullName
        cell.detailTextLabel?.text = races.first?.resultArray[indexPath.row].timeResult?.time ?? "No race time"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            view.textLabel?.textColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = URL(string: (races.first?.resultArray[indexPath.row].driver.url)!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
