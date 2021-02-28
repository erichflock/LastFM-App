//
//  AlbumDetailsView.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class AlbumDetailView: UIView, UITableViewDataSource {
    
    struct ViewModel {
        var albumTitle: String
        var artistName: String
        var tracks: [Album.Track]
        var imageUrlString: String?
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private let albumImageView = UIImageView()
    private let albumTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let tracksTableView = UITableView()
    
    private var tracks: [Album.Track] = [] {
        didSet {
            tracksTableView.reloadData()
        }
    }
    
    var viewModel: ViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func setupUI() {
        setupAlbumImageView()
        setupAlbumTitleLabel()
        setupArtistNameLabel()
        setupTracksTableView()
    }
    
    private func setupAlbumImageView() {
        albumImageView.image = UIImage(systemName: "music.note")
        
        addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumImageView.heightAnchor.constraint(equalToConstant: 174),
            albumImageView.widthAnchor.constraint(equalToConstant: 174),
            albumImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            albumImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupAlbumTitleLabel() {
        albumTitleLabel.text = "Miami Beach (2019)"
        albumTitleLabel.textColor = .darkText
        albumTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        albumTitleLabel.numberOfLines = 1
        albumTitleLabel.textAlignment = .left
        
        addSubview(albumTitleLabel)
        albumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumTitleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 8),
            albumTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            albumTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
        ])
    }
    
    private func setupArtistNameLabel() {
        artistNameLabel.text = "Wesley Safadao"
        artistNameLabel.textColor = .darkText
        artistNameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        artistNameLabel.numberOfLines = 1
        artistNameLabel.textAlignment = .left
        
        addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: albumTitleLabel.bottomAnchor, constant: 4),
            artistNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            artistNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
        ])
    }
    
    private func setupTracksTableView() {
        tracksTableView.dataSource = self
        
        addSubview(tracksTableView)
        tracksTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tracksTableView.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 8),
            tracksTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            tracksTableView.leftAnchor.constraint(equalTo: leftAnchor),
            tracksTableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func updateUI() {
        updateAlbumImageView()
        updateAlbumTitleLabel()
        updateArtistNameLabel()
        updateTracks()
    }
    
    private func updateAlbumImageView() {
        guard let imageUrlString = viewModel?.imageUrlString, let imageUrl = URL(string: imageUrlString) else { return }
        albumImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(systemName: "music.note"))
    }
    
    private func updateAlbumTitleLabel() {
        guard let title = viewModel?.albumTitle else { return }
        albumTitleLabel.text = title
    }
    
    private func updateArtistNameLabel() {
        guard let artistName = viewModel?.artistName else { return }
        artistNameLabel.text = artistName
    }
    
    private func updateTracks() {
        guard let updatedTracks = viewModel?.tracks else { return }
        tracks = updatedTracks
    }
}

//MARK: - UITableViewDataSource
extension AlbumDetailView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let track = getTrack(for: indexPath) {
            cell.textLabel?.text = track.name
        }
        return cell
    }
    
    private func getTrack(for indexPath: IndexPath) -> Album.Track? {
        guard indexPath.row <= tracks.count else { return nil }
        return tracks[indexPath.row]
    }
}

