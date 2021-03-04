//
//  AlbumDetailsViewController.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
    
    let albumTitle: String
    let artistName: String
    
    let albumDetailView = AlbumDetailView()
    private var album: Album?
    
    var coreDataManager: CoreDataManagerSaveProtocol & CoreDataManagerDeleteProtocol & CoreDataManagerFetchAlbumProtocol = CoreDataManager.shared
    
    init(albumTitle: String, artistName: String) {
        self.albumTitle = albumTitle
        self.artistName = artistName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAlbum()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlbumDetailView()
        loadAlbum()
    }
    
    func setupTitle() {
        title = albumTitle
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
    
    private func updateAlbum() {
        guard var album = album else { return }
        let albumSaved = coreDataManager.fetch(album: album) != nil ? true : false
        album.isSaved = albumSaved
        albumDetailView.viewModel = .init(album: album)
    }
}

//MARK: - API Request
extension AlbumDetailsViewController {
    
    private func loadAlbum() {
        AlbumAPIRequests.fetchAlbumInformation(albumName: albumTitle, artistName: artistName, completion: { [weak self] albumAPIModel in
            guard let self = self else { return }
            if let album = self.createAlbum(albumFromAPI: albumAPIModel) {
                self.album = album
                self.albumDetailView.viewModel = .init(album: album)
            }
        })
    }
}

//MARK: - Mapper
extension AlbumDetailsViewController {

    private func createAlbum(albumFromAPI: AlbumInformation?) -> Album? {
        guard let albumFromAPI = albumFromAPI else { return nil }
        if let title = albumFromAPI.name, let artistName = albumFromAPI.artist, let tracks = albumFromAPI.tracks?.tracks, let image = albumFromAPI.image?.first(where: { $0.size == .large }) {
            return .init(name: title, imageURLString: image.text ?? "", artistName: artistName, tracks: mapTracks(albumTracksAPI: tracks))
        }
        return nil
    }

    private func mapTracks(albumTracksAPI: [AlbumInformation.AlbumTracks.Track]) -> [Album.Track] {
        var tracks: [Album.Track] = []
        for trackAPI in albumTracksAPI {
            if let name = trackAPI.name {
                tracks.append(.init(name: name))
            }
        }
        return tracks
    }
}

//MARK: - AlbumDetailsViewDelegate
extension AlbumDetailsViewController: AlbumDetailViewDelegate {
    
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
