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
    }
}
