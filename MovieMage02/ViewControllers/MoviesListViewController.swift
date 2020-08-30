//
//  MoviesListViewController.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    //injected from SceneDelegate when scene is created at app launch
    var networkManager: NetworkManager!
    
    //instantiated in viewDidLoad()
    var viewModel: MoviesListViewModel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MoviesListViewModel(networkMgr: networkManager)
        
        searchBar.delegate = self

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
        
        searchBar.resignFirstResponder()
        viewModel.searchForMovies(matching: searchText, page: 1) { (results) in
            switch results {
            case .success(let numberOfResults):
                print("successful search: retrieved \(numberOfResults) movies")
                print("number of movies in movies list for view: \(self.viewModel.moviesWithImageData.count)")
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

