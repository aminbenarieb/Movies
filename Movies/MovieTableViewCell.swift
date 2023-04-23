//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Amin Benarieb on 4/23/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let margin: CGFloat = 10

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 2/3),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin),
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: margin),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = String(movie.releaseDate.prefix(4))
        let posterPath = movie.posterPath
        
        let baseUrl = "https://image.tmdb.org/t/p/"
        let imageSize = "w185"
        let urlString = "\(baseUrl)\(imageSize)\(posterPath)"
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }

            if let error = error {
                print("Error fetching poster image: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from API")
                return
            }

            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }.resume()
        
    }
}
