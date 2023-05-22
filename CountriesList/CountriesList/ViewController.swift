//
//  ViewController.swift
//  CountriesList
//
//  Created by Vijay Thota on 5/17/23.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var countries:[Country] = []
    let serviceManager = ServiceManager()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData : [Country] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Country"
        definesPresentationContext = true

        //Fetching the data from Service
        serviceManager.getCountries { result in
            switch result {
            case .success(let countries):
                DispatchQueue.main.async {
                    self.countries = countries
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.displayErrorMessage(error: error)
                }
            }
        }
    }
    
    // UISearchbarConroller Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filterContentForSearchText(searchText: searchText)
        } else {
            
        }
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText : String) {
        self.filteredData = self.countries.filter { (country: Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased()) || country.capital.lowercased().contains(searchText.lowercased())
        }
    }
    
    func displayErrorMessage(error: Error){
        let alert = UIAlertController(title: "Failure", message: error.localizedDescription, preferredStyle: .alert)
        let action =  UIAlertAction(title: "Ok", style: .default) { (alert:UIAlertAction!) -> Void in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDataSource {
    // UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! CustomTableCell
        let country : Country
        if isFiltering {
            country = filteredData[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        cell.nameAndRegionLabel.text = country.name + ", " + country.region
        cell.capitalLabel.text = country.capital
        cell.codeLabel.text = country.code

        return cell
    }
}
