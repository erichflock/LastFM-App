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
    
    var viewModel: ViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func setupUI() {
        setupArtistLabel()
        setupListenersCountLabel()
    }
    
    private func setupArtistLabel() {
        artistNameLabel.textColor = .darkText
        artistNameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            artistNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            artistNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
    }
    
    private func setupListenersCountLabel() {
        listenersCountLabel.textColor = .darkText
        listenersCountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        contentView.addSubview(listenersCountLabel)
        listenersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listenersCountLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 4),
            listenersCountLabel.leftAnchor.constraint(equalTo: artistNameLabel.leftAnchor),
            listenersCountLabel.rightAnchor.constraint(equalTo: artistNameLabel.rightAnchor),
            listenersCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
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
