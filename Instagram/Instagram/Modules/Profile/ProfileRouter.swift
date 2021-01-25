//
//  ProfileRouter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfileRouter: AnyObject {
    func showLoginViewController()
}

final class ProfileRouter {
    private weak var viewController: ProfileViewController?
    
    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
}

// MARK: - IProfileRouter

extension ProfileRouter: IProfileRouter {
    func showLoginViewController() {
        let loginViewController = LoginAssembly.createLoginViewController()
        
        RootViewControllerSwitcher.setRootViewController(loginViewController)
    }
}
