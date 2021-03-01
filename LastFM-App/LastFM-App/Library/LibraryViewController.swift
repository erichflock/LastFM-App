//
//  LibraryViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 01.03.21.
//

import UIKit

class LibraryViewController: UIViewController {
    
    var albums: [Album] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    private var collectionView: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albums = CoreDataManager.shared.fetchAlbums()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTitle()
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
        guard albums.count >= item else { return nil }
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
