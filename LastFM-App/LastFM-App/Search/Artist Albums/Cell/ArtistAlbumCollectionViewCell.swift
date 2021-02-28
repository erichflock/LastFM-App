//
//  ArtistAlbumCollectionViewCell.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit
import AlamofireImage

class ArtistAlbumCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        var imageUrlString: String?
        var title: String
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
    private let titleLabel = UILabel()
    
    var viewModel: ViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func setupUI() {
        setupAlbumImageView()
        setupTitleLabel()
    }
    
    private func setupAlbumImageView() {
        albumImageView.image = UIImage(systemName: "music.note")
        
        contentView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumImageView.heightAnchor.constraint(equalToConstant: 64),
            albumImageView.widthAnchor.constraint(equalToConstant: 64),
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            albumImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            albumImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.textColor = .darkText
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    private func updateUI() {
        updateTitleLabel()
        updateAlbumImageView()
    }
    
    private func updateTitleLabel() {
        guard let title = viewModel?.title else { return }
        titleLabel.text = title
    }
    
    private func updateAlbumImageView() {
        guard let imageUrlString = viewModel?.imageUrlString, let imageUrl = URL(string: imageUrlString) else { return }
        albumImageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(systemName: "music.note"))
    }
}
