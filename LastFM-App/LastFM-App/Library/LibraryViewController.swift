//
//  LibraryViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 01.03.21.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private(set) var albums: [Album] = [] {
        didSet {
            collectionView?.reloadData()
            if albums.isEmpty {
                addEmptyLibraryView()
            } else {
                removeEmptyLibraryView()
            }
        }
    }
    
    private(set) var emptyLibraryView: UIStackView?
    private(set) var collectionView: UICollectionView?
    lazy private(set) var removeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(showRemoveAlbumsAlert))
    var coreDataManager: CoreDataManagerFetchProtocol & CoreDataManagerDeleteAllProtocol = CoreDataManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albums = coreDataManager.fetchAlbums()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTitle()
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupTitle() {
        title = "Library"
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: 96, height: 84)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ArtistAlbumCollectionViewCell.self, forCellWithReuseIdentifier: "ArtistAlbumCollectionViewCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
        ])
    }
    
    private func setupNavigationBar() {
        removeBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = removeBarButtonItem
    }
    
    @objc private func showRemoveAlbumsAlert() {
        guard !albums.isEmpty else { return }
        let alert = UIAlertController(title: "Remove all albums from your Library?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.removeAlbums()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func removeAlbums() {
        coreDataManager.deleteAll()
        albums = coreDataManager.fetchAlbums()
    }
    
    private func addEmptyLibraryView() {
        let emptyLibraryImageView = UIImageView(image: UIImage(named: "empty"))
        let messageLabel = UILabel()
        messageLabel.text = "Your Library is Empty"
        messageLabel.textColor = .black
        messageLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        emptyLibraryView = UIStackView()
        emptyLibraryView?.axis = .vertical
        emptyLibraryView?.alignment = .center
        emptyLibraryView?.distribution = .fill
        emptyLibraryView?.spacing = 16
        emptyLibraryView?.addArrangedSubview(emptyLibraryImageView)
        emptyLibraryView?.addArrangedSubview(messageLabel)
        
        if let emptyLibraryView = emptyLibraryView {
            view.addSubview(emptyLibraryView)
            emptyLibraryView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyLibraryView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyLibraryView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }
    
    private func removeEmptyLibraryView() {
        emptyLibraryView?.removeFromSuperview()
        emptyLibraryView = nil
    }
}

//MARK: - UICollectionViewDataSource
extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistAlbumCollectionViewCell", for: indexPath) as? ArtistAlbumCollectionViewCell
        if let album = getAlbum(item: indexPath.item) {
            cell?.viewModel = .init(imageUrlString: album.imageURLString, title: album.name)
        }
        return cell ?? UICollectionViewCell()
    }
    
    private func getAlbum(item: Int) -> Album? {
        guard albums.count > item else { return nil }
        return albums[item]
    }
}

//MARK: - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album = getAlbum(item: indexPath.item) {
            let albumDetailsViewController = LibraryAlbumDetailsViewController(album: album)
            navigationController?.pushViewController(albumDetailsViewController, animated: true)
        }
    }
}
