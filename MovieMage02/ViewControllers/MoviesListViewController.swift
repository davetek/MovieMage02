//
//  MoviesListViewController.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    //for use by the view model so it does not need to import UIKit
    typealias Image = UIImage
    
    //injected from SceneDelegate when scene is created at app launch
    var networkManager: NetworkManager!
    
    //instantiated in viewDidLoad()
    var viewModel: MoviesListViewModel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MoviesListViewModel(networkMgr: networkManager)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        //move these functions to MovieDetailsViewController
        
//        viewModel.getMovie(withId: 767) { (results) in
//            switch results {
//            case .success(let idForRetrievedMovie):
//                print("successfully retrieved data for movie \(idForRetrievedMovie)")
//            case .failure(let movieDetailsError):
//                switch movieDetailsError {
//                case .errorRetrievingResults(let errorMsg):
//                    print(errorMsg)
//                }
//            }
//        }
//
//        viewModel.getCredits(forMovieId: 767) { (results) in
//            switch results {
//            case .success(let castArray):
//                print("successfully retrieved \(castArray.count) cast members")
//
//            case .failure(let movieCreditsError):
//                switch movieCreditsError {
//                case .errorRetrievingResults(let errorMsg):
//                    print(errorMsg)
//                case .errorEmptyCastList(let errorMsg):
//                    print(errorMsg)
//                }
//            }
//        }
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            let alert = UIAlertController(title: "Cut!", message: "Please enter your search terms and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        guard searchText != viewModel.searchText else {
            return
        }
        
        searchBar.resignFirstResponder()
        viewModel.searchForMovies(matching: searchText, page: 1) { [weak self]
            (results) in
            guard let self = self else {
                return
            }
            switch results {
            case .success(let numberOfResults):
                
                print("successful search: retrieved \(numberOfResults) movies")
                print("number of movies in movies list for view: \(self.viewModel.moviesWithImageData.count)")
                let firstIndex = self.tableView.numberOfRows(inSection: 0)
                print("first index: \(firstIndex)")
                print("number of results: \(numberOfResults)")
                let resultsCount = self.viewModel.results.count
                print("results count: \(resultsCount)")

                let indexPaths = (firstIndex..<firstIndex + resultsCount).map { (index) in
                    return IndexPath(row: index, section: 0)
                }
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                
                self.viewModel.getAndSetImageForEachMovie { [weak self](results) in
                    guard let self = self else {
                        return
                    }
                    
                    switch results {
                    case .success(let index):
                        print("success case for getAndSetImage...")
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    case .failure(.errorNoImagePath(let errorMsg)):
                        print(errorMsg)
                    case .failure(.errorGettingImageDataForImagePath(let errorMsg)):
                        print(errorMsg)
                    case .failure(.errorNoMoviesInList(let errorMsg)):
                        print(errorMsg)
                    }
                }
                self.tableView.reloadData()
                
            case .failure(let viewModelError):
                switch viewModelError {
                case .emptyResults(let emptyResultsMessage):
                    print(emptyResultsMessage)
                case .errorRetrievingResults(let retrievalErrorMessage):
                    print(retrievalErrorMessage)
                }
            }
        }
    }
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.moviesWithImageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell", for: indexPath) as! MoviesListTableViewCell
        let movieViewModel = viewModel.moviesWithImageData[indexPath.row]
        
        //populate cell
        cell.movieTitleLabel.text = movieViewModel.title
        if let posterImage = movieViewModel.posterImage {
            cell.moviePosterImageView.image = posterImage
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
}
