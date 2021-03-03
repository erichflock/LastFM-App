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
    
    private let albumDetailView = AlbumDetailView()
    
    var coreDataManager: CoreDataManagerSaveProtocol & CoreDataManagerDeleteProtocol = CoreDataManager.shared
    
    init(albumTitle: String, artistName: String) {
        self.albumTitle = albumTitle
        self.artistName = artistName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

//MARK: - API Request
extension AlbumDetailsViewController {
    
    private func loadAlbum() {
        AlbumAPIRequests.fetchAlbumInformation(albumName: albumTitle, artistName: artistName, completion: { [weak self] albumAPIModel in
            guard let self = self else { return }
            self.albumDetailView.viewModel = self.createAlbumDetailViewModel(albumFromAPI: albumAPIModel)
        })
    }
}

//MARK: - Mapper
extension AlbumDetailsViewController {

    private func createAlbumDetailViewModel(albumFromAPI: AlbumInformation?) -> AlbumDetailView.ViewModel? {
        guard let albumFromAPI = albumFromAPI else { return nil }
        if let title = albumFromAPI.name, let artistName = albumFromAPI.artist, let tracks = albumFromAPI.tracks?.tracks, let image = albumFromAPI.image?.first(where: { $0.size == .large }) {
            return .init(album: .init(name: title, imageURLString: image.text ?? "", artistName: artistName, tracks: mapTracks(albumTracksAPI: tracks)))
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
        isSelected ? coreDataManager.saveAlbum(newAlbum: album) : coreDataManager.deleteAlbum(album: album)
    }
}
