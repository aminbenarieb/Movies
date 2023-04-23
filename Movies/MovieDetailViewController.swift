import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    private let movie: Movie

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = movie.title
        configureViews()
        configureConstraints()
        fetchPosterImage()
    }

    private func configureViews() {
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(overviewLabel)

        titleLabel.text = movie.title
        releaseDateLabel.text = "Release date: " + movie.releaseDate
        overviewLabel.text = movie.overview
    }

    private func configureConstraints() {
        let margin: CGFloat = 20

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),

            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),

            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: margin),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            overviewLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin)
        ])
    }

    private func fetchPosterImage() {
        let posterPath = movie.posterPath
        let baseUrl = "https://image.tmdb.org/t/p/"
        let imageSize = "w500"
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
