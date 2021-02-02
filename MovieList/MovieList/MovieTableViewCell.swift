//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by SaJesh Shrestha on 2/2/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let identifer = "MovieTableViewCell"

    var posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    var year: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    var imdbID: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let padding: CGFloat = 10
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        UILayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        posterImageView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        year.translatesAutoresizingMaskIntoConstraints = false
//        imdbID.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(year)
        contentView.addSubview(imdbID)

    }
    
    private func UILayout() {
        NSLayoutConstraint.activate([
            posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding),
            posterImageView.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            year.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            year.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            imdbID.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 6),
            imdbID.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        ])
    }
}
