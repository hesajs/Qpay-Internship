//
//  ViewController.swift
//  MovieList
//
//  Created by SaJesh Shrestha on 2/2/21.
//

import UIKit
import CoreData
import Network

class ViewController: UIViewController {
    
    let endpoint = "https://fake-movie-database-api.herokuapp.com/api?s=batman"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableView = UITableView(frame: .zero)
    var movies: [MovieProp] = []
    var images: [UIImage] = []
    var coreDataMovie: [MovieProps] = []
    var isNetwork = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Fake Movie List"
        view.backgroundColor = .systemBackground
        
        configureTableView()
        tableUILayout()
//        fetchData(endpoint: endpoint)
//        fetchFromCoreData()
        monitorNetwork()
    }
    
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.fetchData(endpoint: self.endpoint)
                }
            } else {
                DispatchQueue.main.async {
                    self.fetchFromCoreData()
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
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
        isNetwork = true
        showLoadingView()
        print("JSON Data")
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
                            self.downloadImage(from: jdata.posterImage)
                            
                            //MARK: Insert to Core Data
                            let newMovie = MovieProps(context: self.context)
                            newMovie.imdbID = jdata.imdbID
                            newMovie.title = jdata.movieTitle
                            newMovie.year = jdata.year
                            newMovie.posterImage = self.getImage(from: jdata.posterImage).pngData()
                            try! self.context.save()
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
    
    
    func fetchFromCoreData() {
        isNetwork = false
        print("CoreData")
        do {
            coreDataMovie = try context.fetch(MovieProps.fetchRequest())
        } catch {
            print("Error while fetching... \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func downloadImage(from string: String) {
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
    
    
    func getImage(from string: String) -> UIImage {
        var img = #imageLiteral(resourceName: "noimage")
        if let url = URL(string: string) {
            if let data = try? Data(contentsOf: url, options: []) {
                if let image = UIImage(data: data) { img = image }
            }
        }
        return img
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifer, for: indexPath) as! MovieTableViewCell
        
        //TODO: Display json fetched data
        
        if isNetwork {
            print("Inside network")
            if !movies.isEmpty {
                cell.imdbID.text = movies[indexPath.row].imdbID
                cell.titleLabel.text = movies[indexPath.row].movieTitle
                cell.year.text = movies[indexPath.row].year
                cell.posterImageView.image = images[indexPath.row]
            } else {
                cell.imdbID.text = "yo boie"
                cell.titleLabel.text = "yo boie"
                cell.year.text = "yo boie"
                cell.posterImageView.image = #imageLiteral(resourceName: "noimage")
            }
        } else {
            print("Inside CoreData")
            if !coreDataMovie.isEmpty {
                cell.imdbID.text = coreDataMovie[indexPath.row].imdbID
                cell.titleLabel.text = coreDataMovie[indexPath.row].title
                cell.year.text = coreDataMovie[indexPath.row].year
                cell.posterImageView.image = UIImage(data: coreDataMovie[indexPath.row].posterImage!)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
