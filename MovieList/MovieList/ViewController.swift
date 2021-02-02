//
//  ViewController.swift
//  MovieList
//
//  Created by SaJesh Shrestha on 2/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    let endpoint = "https://fake-movie-database-api.herokuapp.com/api?s=batman"
    var tableView = UITableView(frame: .zero)
    var movies: [MovieProp] = []
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Fake Movie List"
        view.backgroundColor = .systemBackground
        
        configureTableView()
        tableUILayout()
        fetchData(endpoint: endpoint)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    func tableUILayout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func fetchData(endpoint: String) {
        showLoadingView()
        if let url = URL(string: endpoint) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(Movies.self, from: data)
                    DispatchQueue.main.async {
                        for jdata in jsonData.Search {
                            self.movies.append(jdata)
                            self.getImage(from: jdata.Poster)
                        }
                        self.dismissLoadingView()
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
            }.resume()
        }
        tableView.reloadData()
    }
    
    func getImage(from string: String) {
//        self.images.removeAll()
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return
        }
        
        do {
            if let data =  try? Data(contentsOf: url, options: []){
                if let image = UIImage(data: data) {
                    images.append(image)
                }else{ images.append(#imageLiteral(resourceName: "noimage")) }
                
                self.tableView.reloadData()
            }
            
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifer, for: indexPath) as! MovieTableViewCell
        
        if !movies.isEmpty {
            
            cell.imdbID.text = movies[indexPath.row].imdbID
            cell.titleLabel.text = movies[indexPath.row].Title
            cell.year.text = movies[indexPath.row].Year
            cell.posterImageView.image = images[indexPath.row]
        } else {
            cell.imdbID.text = "yo boie"
            cell.titleLabel.text = "yo boie"
            cell.year.text = "yo boie"
            cell.posterImageView.image = #imageLiteral(resourceName: "noimage")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}