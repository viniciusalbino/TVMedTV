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
    private var functionRequest = FunctionRequest()
    private var tokenPersister = TokenPersister()
    
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
        
//        self.searchContainerDisplay()
//        self.reloadTabBarControllers(work: false)
        
        functionRequest.getFunctionWorking { work, error in
            DispatchQueue.main.async {
                guard let workResult = work, error == nil else {
                    self.checkWork()
                    return
                }
                let workOverride = WorkResult()
//                workOverride.status = 1
                
                do {
                    let realm = try RealmEncrypted.realm()
                    try realm.write {
                        realm.add(workResult, update: true)
                    }
                } catch {
                    print("Realm did not save work result!")
                }
                
                self.checkWork()
            }
        }
    }
    
    func checkWork() {
        DispatchQueue.main.async {
            do {
                let realm = try RealmEncrypted.realm()
                let objects = Array(realm.objects(WorkResult.self))
                if let workResult = objects.last {
                    self.checkLoggedUser(work: Bool(workResult.status))
                } else {
                    self.reloadTabBarControllers(work: false)
                }
            } catch {
                self.reloadTabBarControllers(work: false)
                print("Realm did not query workResult objects!")
            }
        }
    }
    
    func checkLoggedUser(work: Bool) {
        DispatchQueue.main.async {
            do {
                let realm = try RealmEncrypted.realm()
                let objects = Array(realm.objects(UserToken.self))
                if let userToken = objects.first {
                    if userToken.email == "informatica@tvmed.com.br" && work == false {
                        self.reloadTabBarControllers(work: false)
                    } else if userToken.email == "informatica@tvmed.com.br" && work == true {
                        //logout default user
                        self.tokenPersister.delete { _ in
                            self.reloadTabBarControllers(work: true)
                        }
                    } else {
                        self.reloadTabBarControllers(work: true)
                    }
                    
                } else {
                    if work == false {
                        self.loginRequest(email: "informatica@tvmed.com.br", password: "testeinfo147")
                    } else {
                        self.reloadTabBarControllers(work: true)
                    }
                }
            } catch {
                self.reloadTabBarControllers(work: false)
                print("Realm did not query workResult objects!")
            }
        }
    }
    
    func loginRequest(email: String, password: String) {
        let loginDTO = LoginDTO(email: email, password: password, rememberMe: true, qualtab: 0)
        let request = LoginRequest()
        request.request(loginDTO: loginDTO) { token, error in
            guard error == nil, let userToken = token else {
                DispatchQueue.main.async {
                    self.reloadTabBarControllers(work: false)
                }
                return
            }
            DispatchQueue.main.async {
                self.reloadTabBarControllers(work: false)
            }
        }
    }
    
    func reloadTabBarControllers(work: Bool) {
        let showCaseController = UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "UINavigationController-fyJ-Z7-Ah4") as! UINavigationController
        let meusDados = UIStoryboard(name: "MeusDados", bundle: nil).instantiateViewController(withIdentifier: "MeusDadosNavigation")
        
        self.viewControllers = [showCaseController]
        
        self.tabBar.items?[0].title = work ? "Meus Produtos" : "Showcase"
        if work {
            self.viewControllers?.append(meusDados)
            self.tabBar.items?[1].title = "Meus Dados"
            
        }
        
//        if let tbItems = self.tabBar.items {
//            //            let tabBarItem1: UITabBarItem = tbItems[0]
//            let tabBarItem2: UITabBarItem = tbItems[0]
//            //            let tabBarItem3: UITabBarItem = tbItems[2]
//            //            let tabBarItem4: UITabBarItem = tbItems[2]
//            let tabBarItem5: UITabBarItem = tbItems[1]
//            //            tabBarItem1.title = "Home"
//            tabBarItem2.title = work ? "Meus Produtos" : "Showcase"
//            //            tabBarItem3.title = "Busca"
//            //            tabBarItem4.title = "Carrinho"
//            tabBarItem5.title = "Meus Dados"
//        }
        
    }
}
