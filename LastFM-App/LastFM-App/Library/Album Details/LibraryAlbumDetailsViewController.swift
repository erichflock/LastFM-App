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
    
    private func setupTitle() {
        title = album.name
    }
    
    private func setupAlbumDetailView() {
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
    
    private func showAlbumSavedAlert() {
        let alert = UIAlertController(title: "Album Saved", message: "Album added to your Library", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showAlbumDeletedAlert() {
        let alert = UIAlertController(title: "Album Deleted", message: "Album removed from your Library", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

//MARK: - AlbumDetailViewDelegate
extension LibraryAlbumDetailsViewController: AlbumDetailViewDelegate {
    
    func didTapSaveButton(isSelected: Bool, album: Album) {
        if isSelected {
            coreDataManager.saveAlbum(newAlbum: album)
            showAlbumSavedAlert()
        } else {
            coreDataManager.deleteAlbum(album: album)
            showAlbumDeletedAlert()
        }
    }
    
}
