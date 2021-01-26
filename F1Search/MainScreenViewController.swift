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
    
    
    var search = Search()
    
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
        if search.isLodaing{HUD.show(.labeledProgress(title: "Lodaing...", subtitle: nil))}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        HUD.hide()
    }
    
    func performSearch(){
        search.performSearchFor() { [weak self] success in
            HUD.hide()
            guard let weakSelf = self else {return}
            if !success {
                print("URL request Error")
                HUD.flash(.labeledError(title: "Error during request", subtitle: nil), delay: 2.0)
            }
            if weakSelf.search.searchResults.isEmpty{
                HUD.flash(.label("No data available"), delay: 2.0)
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        if segue.identifier == "Details"{
            let controller = segue.destination as! DetailsViewController
            controller.search.searchPosition = ""
            controller.search.headerURL = search.searchResults[index].url
            controller.search.category = search.searchResults[index].round
        }
    }
}

// MARK: - Table view delegate
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinnerCell", for: indexPath)
        cell.textLabel?.text = search.searchResults[indexPath.row].resultArray.first?.fullName
        cell.detailTextLabel?.text = search.searchResults[indexPath.row].raceName
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !search.searchResults.isEmpty{
            return "Winners in  \(search.searchResults.first!.season) season"
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
