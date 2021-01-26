//
//  DetailsViewController.swift
//  F1Search
//
//  Created by Константин Чернов on 20.01.2021.
//

import UIKit
import PKHUD

class DetailsViewController: UIViewController {
    
    var search = Search()
    
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var headerDetailtext: UILabel!
    @IBAction func showWikiForRace(_ sender: UIControl) {
        if let url = URL(string: search.headerURL) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if search.isLodaing{HUD.show(.labeledProgress(title: "Lodaing...", subtitle: nil))}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            weakSelf.updateLabels()
            weakSelf.tableView.reloadData()
        }
    }
    
    func updateLabels(){
        if let race = search.searchResults.first?.raceName, let date = search.searchResults.first?.date,
           let round = search.searchResults.first?.round{
            headerText.text = search.searchYear + " - " + round
            headerDetailtext.text = race + "  " + date
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.searchResults.first?.resultArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = search.searchResults.first?.resultArray[indexPath.row].fullName
        cell.detailTextLabel?.text = search.searchResults.first?.resultArray[indexPath.row].timeResult?.time ?? "No race time"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView{
            view.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            view.textLabel?.textColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = URL(string: (search.searchResults.first?.resultArray[indexPath.row].driver.url)!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
