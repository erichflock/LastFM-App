//
//  SearchViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Artists"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupTableView() {
        tableView.register(ArtistTableViewCell.self,  forCellReuseIdentifier: "ArtistTableViewCell")
    }
    
}


//MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}

//MARK: - UITableViewDataSource
extension SearchTableViewController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as? ArtistTableViewCell
        cell?.viewModel = .init(name: "Wesley Safadao", listenersCount: 1000)
        return cell ?? UITableViewCell()
    }
    
}

//MARK: - UITableViewDelegate
extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select Row At \(indexPath.row)")
        let artistAlbumsViewController = ArtistAlbumsViewController()
        navigationController?.pushViewController(artistAlbumsViewController, animated: true)
    }
    
}
