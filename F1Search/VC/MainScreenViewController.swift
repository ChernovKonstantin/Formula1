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
    
    var races = [Race]()
    let search = Request()
    let requestMaker: URLRequestable = URLRequestMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        performSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if search.isLodaing { showHUD(for: .lodaing) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        showHUD(for: .stopAnimating)
    }
    
    func performSearch(){
        search.isLodaing = true
        requestMaker.performSearchFor(request: search) { [weak self] (result: Result<SearchResult, RequestError>) in
            guard let weakSelf = self else {return}
            switch result{
            case .success(let data): weakSelf.races = data.responseData.table.races;
                DispatchQueue.main.async {
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        if segue.identifier == "Details"{
            let controller = segue.destination as! DetailsViewController
            controller.search.searchPosition = ""
            controller.search.detailScreenHeaderURL = races[index].url
            controller.search.searchRaceRound = races[index].round
        }
    }
}

// MARK: - Table view delegate
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return races.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinnerCell", for: indexPath)
        cell.textLabel?.text = races[indexPath.row].resultArray.first?.fullName
        cell.detailTextLabel?.text = races[indexPath.row].raceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !races.isEmpty{
            return "Winners in  \(races.first!.season) season"
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView{
            view.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            view.textLabel?.textColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
