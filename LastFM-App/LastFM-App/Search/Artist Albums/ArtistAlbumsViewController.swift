//
//  ArtistAlbumsViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class ArtistAlbumsViewController: UIViewController {
    
    let artistName: String
    var albums: [Album] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    private var collectionView: UICollectionView?
    
    init(artistName: String) {
        self.artistName = artistName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAlbums()
    }
    
    private func setupUI() {
        setupTitle()
        setupCollectionView()
    }
    
    private func setupTitle() {
        title = "Albums"
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
extension ArtistAlbumsViewController: UICollectionViewDataSource {
    
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
extension ArtistAlbumsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album = getAlbum(item: indexPath.item) {
            let albumDetailsViewController = AlbumDetailsViewController(albumTitle: album.name, artistName: album.artistName)
            navigationController?.pushViewController(albumDetailsViewController, animated: true)
        }
    }
}

//MARK: - API Request
extension ArtistAlbumsViewController {
    
    private func loadAlbums() {
        AlbumAPIRequests.fetchAlbums(query: artistName, completion: { [weak self] albumsFromAPI in
            guard let self = self else { return }
            self.albums = self.createAlbums(albumsFromAPI: albumsFromAPI)
        })
    }
}

//MARK: - Mapper
extension ArtistAlbumsViewController {

    private func createAlbums(albumsFromAPI: [AlbumAPIModel]?) -> [Album] {
        guard let albumsFromAPI = albumsFromAPI else { return [] }
        var album: [Album] = []
        for albumFromAPI in albumsFromAPI {
            if let name = albumFromAPI.name, let image = albumFromAPI.image?.first(where: { $0.size == .medium }), let artistName = albumFromAPI.artist?.name {
                album.append(.init(name: name, imageURLString: image.text ?? "", artistName: artistName))
            }
        }
        return album
    }
}
