//
//  AppCoordinator.swift
//  Instagram
//
//  Created by Admin on 12.03.2021.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
}

// MARK: - Interface

extension AppCoordinator {
    func start() {
        startAuthFlow()
        
        if FirebaseAuthService.isUserSignedIn {
            startMainFlow()
        }
    }
}

// MARK: - AuthCoordinatorDelegate

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinishAuthentication(_ authCoordinator: AuthCoordinator) {
        //removeAllChildCoordinators()
        
        startMainFlow()
    }
}

// MARK: - Private Methods

private extension AppCoordinator {
    func startAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, delegate: self)
        
        authCoordinator.start()
        
        appendChildCoordinator(authCoordinator)
    }

    func startMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        
        mainCoordinator.start()
        
        appendChildCoordinator(mainCoordinator)
    }
}