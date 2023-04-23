//
//  ViewController.swift
//  Movies
//
//  Created by Amin Benarieb on 4/23/23.
//

import UIKit

class TrendingMoviesViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        return tableView
    }()

    private let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"

    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trending Movies"

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        fetchMovies()
    }

    private func fetchMovies() {
        let urlString = "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }

            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from API")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                self.movies = response.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding movies: \(error.localizedDescription)")
            }
        }.resume()
    }

}

extension TrendingMoviesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]
        cell.configure(with: movie)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let vc = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }

}
