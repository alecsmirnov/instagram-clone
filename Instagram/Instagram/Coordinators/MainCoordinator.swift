//
//  MainCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

final class MainCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Interface

extension MainCoordinator {
    func start() {
        showMainTabBarController()
    }
}

// MARK: - Private Methods

private extension MainCoordinator {
    func showMainTabBarController() {
        let homeCoordinator = HomeCoordinator()
        let searchCoordinator = SearchCoordinator()
        let profileCoordinator = ProfileCoordinator()
        
        homeCoordinator.start()
        searchCoordinator.start()
        profileCoordinator.start()
  
        appendChildCoordinator(homeCoordinator)
        appendChildCoordinator(searchCoordinator)
        appendChildCoordinator(profileCoordinator)
        
        let mainTabBarController = MainTabBarController()
        
        mainTabBarController.appendNavigationController(homeCoordinator.navigationController, item: .home)
        mainTabBarController.appendNavigationController(searchCoordinator.navigationController, item: .search)
        mainTabBarController.appendNavigationController(UINavigationController(), item: .plus)
        mainTabBarController.appendNavigationController(UINavigationController(), item: .like)
        mainTabBarController.appendNavigationController(profileCoordinator.navigationController, item: .profile)
        
        mainTabBarController.didSelectPlusTabItem = { [weak self] in
            let newPostCoordinator = NewPostCoordinator(presenterController: mainTabBarController, delegate: self)
            
            newPostCoordinator.start()
            
            self?.appendChildCoordinator(newPostCoordinator)
        }
        
        navigationController.pushViewController(mainTabBarController, animated: true)
    }
}

// MARK: - NewPostCoordinatorDelegate

extension MainCoordinator: NewPostCoordinatorDelegate {
    func newPostCoordinatorDidClose(_ newPostCoordinator: NewPostCoordinator) {
        removeChildCoordinator(newPostCoordinator)
    }
}