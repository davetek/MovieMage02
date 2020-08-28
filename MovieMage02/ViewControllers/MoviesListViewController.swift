//
//  ViewController.swift
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MoviesListViewModel(networkMgr: networkManager)

        viewModel.searchForMovies(matching: "harry potter", page: 1)
        
//        viewModel.getMovie(withId: 767) {
//            print("getMovie function was called")
//        }
    }
}

