//
//  LibraryAlbumDetailsViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 01.03.21.
//

import UIKit

class LibraryAlbumDetailsViewController: UIViewController {
    
    let album: Album
    
    let albumDetailView = AlbumDetailView()
    
    var coreDataManager: CoreDataManagerSaveProtocol & CoreDataManagerDeleteProtocol = CoreDataManager.shared
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlbumDetailView()
    }
    
    func setupTitle() {
        title = album.name
    }
    
    func setupAlbumDetailView() {
        view.addSubview(albumDetailView)
        albumDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            albumDetailView.leftAnchor.constraint(equalTo: view.leftAnchor),
            albumDetailView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        albumDetailView.viewModel = .init(album: album)
        albumDetailView.delegate = self
    }
}

//MARK: - AlbumDetailViewDelegate
extension LibraryAlbumDetailsViewController: AlbumDetailViewDelegate {
    
    func didTapSaveButton(isSelected: Bool, album: Album) {
        isSelected ? coreDataManager.saveAlbum(newAlbum: album) : coreDataManager.deleteAlbum(album: album)
    }
    
}
