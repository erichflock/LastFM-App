//
//  ArtistTableViewCell.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    struct ViewModel {
        var name: String
        var listenersCount: Int
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        setupUI()
    }
    
    private let artistNameLabel = UILabel()
    private let listenersCountLabel = UILabel()
    private let arrowRightImageView = UIImageView()
    
    var viewModel: ViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func setupUI() {
        setupArtistLabel()
        setupListenersCountLabel()
        setupArrowRightImageView()
    }
    
    private func setupArtistLabel() {
        artistNameLabel.textColor = .darkText
        artistNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        contentView.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            artistNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8)
        ])
    }
    
    private func setupListenersCountLabel() {
        listenersCountLabel.textColor = .darkText
        listenersCountLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        contentView.addSubview(listenersCountLabel)
        listenersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listenersCountLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 4),
            listenersCountLabel.leftAnchor.constraint(equalTo: artistNameLabel.leftAnchor),
            listenersCountLabel.rightAnchor.constraint(equalTo: artistNameLabel.rightAnchor),
            listenersCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupArrowRightImageView() {
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        arrowRightImageView.image = image
        arrowRightImageView.tintColor = .black
        
        contentView.addSubview(arrowRightImageView)
        arrowRightImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowRightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowRightImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            arrowRightImageView.leftAnchor.constraint(greaterThanOrEqualTo: artistNameLabel.rightAnchor, constant: 4)
        ])
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        artistNameLabel.text = viewModel.name
        listenersCountLabel.text = "Listeners: \(viewModel.listenersCount.description)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = ""
        listenersCountLabel.text = ""
    }
}
