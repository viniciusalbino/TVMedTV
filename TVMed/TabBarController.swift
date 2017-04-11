//
//  TabBarController.swift
//  TVMed
//
//  Created by Vinicius Albino on 02/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate {
    
    var window:UIWindow?
    
    func searchContainerDisplay() {
        let resultsController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let searchController = UISearchController(searchResultsController: resultsController)
        
        searchController.searchResultsUpdater = resultsController
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        let searchPlaceholderText = NSLocalizedString("Busca", comment: "")
        searchController.searchBar.placeholder = searchPlaceholderText
        searchController.searchBar.searchBarStyle = .minimal
        
        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
        let navController = UINavigationController(rootViewController: searchContainerViewController)
        navController.view.backgroundColor = UIColor.black
        
        if var tbViewController = self.viewControllers{
            
            //tbViewController.append(navController)
            //Inserts Search into the 3rd array position
            tbViewController.insert(navController,at: 2)
            self.viewControllers = tbViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchContainerDisplay()
        
        if let tbItems = self.tabBar.items{
            
            let tabBarItem1: UITabBarItem = tbItems[0]
            let tabBarItem2: UITabBarItem = tbItems[1]
            let tabBarItem3: UITabBarItem = tbItems[2]
            let tabBarItem4: UITabBarItem = tbItems[3]
            let tabBarItem5: UITabBarItem = tbItems[4]
            tabBarItem1.title = "Home"
            tabBarItem2.title = "Meus Produtos"
            tabBarItem3.title = "Busca"
            tabBarItem4.title = "Carrinho"
            tabBarItem5.title = "Meus Dados"
        }
    }
}
