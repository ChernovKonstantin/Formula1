//
//  CustomSearchViewController.swift
//  F1Search
//
//  Created by Константин Чернов on 19.01.2021.
//

import UIKit
import iOSDropDown
import PKHUD

class CustomSearchViewController: UIViewController {
    
    let search = Search()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearDropDown: DropDown!
    @IBOutlet weak var positionDropDown: DropDown!
    
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
        if search.isLodaing{HUD.show(.labeledProgress(title: "Lodaing...", subtitle: nil))}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        HUD.hide()
    }
    
    func performSearch(year: String? = nil, position: String? = nil){
        guard self.yearDropDown.optionArray.contains(year ?? search.searchYear),
              self.positionDropDown.optionArray.contains(position ?? search.searchPosition)
        else{HUD.flash(.label("Incorrect input. Please choose data from the list"), delay: 2.0); return}
        
        HUD.show(.labeledProgress(title: "Lodaing...", subtitle: nil))
        search.performSearchFor(year: year, position: position) { [weak self] success in
            HUD.hide()
            guard let weakSelf = self else {return}
            if !success {
                print("URL request Error")
                HUD.flash(.labeledError(title: "Error during request", subtitle: nil), delay: 2.0)
            }
            if weakSelf.search.searchResults.isEmpty{
                HUD.flash(.label("No data available"), delay: 2.0)
                weakSelf.tableView.isHidden = true
            }else {
                weakSelf.tableView.isHidden = false
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    func customizeDropDowns(){
        yearDropDown.text = search.searchYear
        positionDropDown.text = search.searchPosition
        positionDropDown.optionArray = search.positionArr
        yearDropDown.optionArray = search.yearArr
        yearDropDown.didSelect{(year, _, _) in
            self.performSearch(year: year, position: self.positionDropDown.text)
        }
        positionDropDown.didSelect{(position, _, _) in
            self.performSearch(year: self.yearDropDown.text, position: position)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        guard let index = tableView.indexPath(for: cell)?.row else {return}
        if segue.identifier == "CustomDetails"{
            let controller = segue.destination as! DetailsViewController
            controller.search.searchYear = search.searchResults[index].season
            controller.search.searchPosition = ""
            controller.search.headerURL = search.searchResults[index].url
            controller.search.category = search.searchResults[index].round
        }
    }
}

// MARK: - Table view delegate
extension CustomSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchCell", for: indexPath)
        cell.textLabel?.text = search.searchResults[indexPath.row].resultArray.first?.fullName
        cell.detailTextLabel?.text = search.searchResults[indexPath.row].raceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
