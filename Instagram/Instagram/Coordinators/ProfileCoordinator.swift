//
//  ProfileCoordinator.swift
//  Instagram
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol ProfileCoordinatorProtocol: AnyObject {
    
}

final class ProfileCoordinator: CoordinatorProtocol {
    // MARK: Properties
    
    var user: User?
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
}

// MARK: - Interface

extension ProfileCoordinator {
    func start() {
        let profileViewController = ProfileAssembly.createProfileViewController(user: user, coordinator: self)
        
        navigationController.pushViewController(profileViewController, animated: false)
    }
}

// MARK: - ProfileCoordinatorProtocol

extension ProfileCoordinator: ProfileCoordinatorProtocol {
    
}