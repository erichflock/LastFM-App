//
//  ArtistAlbumCollectionViewCell.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

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
        contentView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumImageView.heightAnchor.constraint(equalToConstant: 64),
            albumImageView.widthAnchor.constraint(equalToConstant: 64),
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            albumImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            albumImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.textColor = .darkText
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor)
        ])
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
    }
}
