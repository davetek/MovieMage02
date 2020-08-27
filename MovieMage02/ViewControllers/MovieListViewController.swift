//
//  ViewController.swift
//  MovieMage02
//
//  Created by David Lawrence on 8/22/20.
//  Copyright © 2020 clarity for action. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    //injected from SceneDelegate when scene is created at app launch
    var networkManager: NetworkManager!
    
    //instantiated in viewDidLoad()
    var viewModel: MovieListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieListViewModel(networkMgr: networkManager)
//        viewModel.printMoviesInfo()
//        viewModel.getMoviesInfo()
        
//        viewModel.searchForMovies(matching: "harry potter", page: 1)
        
        viewModel.searchxForMovies(matching: "harry potter", page: 1)
    }


}

