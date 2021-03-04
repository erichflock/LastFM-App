//
//  SearchViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    private(set) var emptySearchView: UIStackView?
    private let searchController = UISearchController()
    private var artists: [Artist] = [] {
        didSet {
            tableView.reloadData()
            artists.isEmpty ? addEmptySearchView() : removeEmptySearchView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupSearchController()
        setupTableView()
        addEmptySearchView()
    }
    
    private func setupTitle() {
        title = "Search"
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Artist"
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupTableView() {
        tableView.register(ArtistTableViewCell.self,  forCellReuseIdentifier: "ArtistTableViewCell")
        tableView.separatorStyle = .none
    }
    
    private func addEmptySearchView() {
        let emptySearchImageView = UIImageView(image: UIImage(named: "rock.music"))
        let messageLabel = UILabel()
        messageLabel.text = "Search your Favorite Artist"
        messageLabel.textColor = .black
        messageLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        emptySearchView = UIStackView()
        emptySearchView?.axis = .vertical
        emptySearchView?.alignment = .center
        emptySearchView?.distribution = .fill
        emptySearchView?.spacing = 8
        emptySearchView?.addArrangedSubview(emptySearchImageView)
        emptySearchView?.addArrangedSubview(messageLabel)
        
        if let emptySearchView = emptySearchView {
            view.addSubview(emptySearchView)
            emptySearchView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptySearchView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                emptySearchView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ])
        }
    }
    
    private func removeEmptySearchView() {
        emptySearchView?.removeFromSuperview()
        emptySearchView = nil
    }
}


//MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let artistName = searchBar.text else { return }
        ArtistAPIRequests.fetchArtists(query: artistName, completion: { [weak self] artistsFromApi in
            guard let self = self else { return }
            self.artists = self.createArtists(artistsFromAPI: artistsFromApi) ?? []
        })
    }
}

//MARK: - UITableViewDataSource
extension SearchTableViewController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as? ArtistTableViewCell
        if let artist = getArtist(row: indexPath.row) {
            cell?.viewModel = .init(name: artist.name, listenersCount: artist.listeners)
        }
        return cell ?? UITableViewCell()
    }
    
    private func getArtist(row: Int) -> Artist? {
        guard artists.count > row else { return nil }
        return artists[row]
    }
}

//MARK: - UITableViewDelegate
extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let artist = getArtist(row: indexPath.row) else { return }
        let artistAlbumsViewController = ArtistAlbumsViewController(artistName: artist.name)
        navigationController?.pushViewController(artistAlbumsViewController, animated: true)
    }
    
}

//MARK: - Mapper
extension SearchTableViewController {
    
    private func createArtists(artistsFromAPI: [ArtistAPIModel]?) -> [Artist]? {
        guard let artistFromAPI = artistsFromAPI else { return nil }
        var artists: [Artist] = []
        for artistFromAPI in artistFromAPI {
            if let name = artistFromAPI.name, let listeners = artistFromAPI.listeners, let listenersConverted = Int(listeners) {
                artists.append(.init(name: name, listeners: listenersConverted))
            }
        }
        return artists
    }
}
