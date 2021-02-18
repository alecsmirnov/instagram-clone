//
//  ProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

protocol IProfilePresenter: AnyObject {
    func viewDidLoad()
    
    func didPressEditButton()
    func didPressFollowButton()
    func didPressUnfollowButton()
    
    func didPressMenuButton()
}

final class ProfilePresenter {
    weak var viewController: IProfileViewController?
    var interactor: IProfileInteractor?
    var router: IProfileRouter?
    
    var user: User?
}

// MARK: - IProfilePresenter

extension ProfilePresenter: IProfilePresenter {
    func viewDidLoad() {
        if let user = user, let identifier = user.identifier {
            if interactor?.isCurrentUserIdentifier(identifier) ?? true {
                viewController?.showEditButton()
            } else {
                viewController?.showFollowButton()
                //interactor?.isFollowingUser(identifier: identifier)
            }
            
            viewController?.setUser(user)
            viewController?.reloadData()
            
            interactor?.fetchPosts(identifier: identifier)
            
            
        } else {
            interactor?.fetchCurrentUser()
        }
    }
    
    func didPressEditButton() {
        
    }
    
    func didPressFollowButton() {
        guard let identifier = user?.identifier else { return }
        
        interactor?.followUser(identifier: identifier)
    }
    
    func didPressUnfollowButton() {
        
    }
    
    func didPressMenuButton() {
        // TODO: move to Menu module
        
        interactor?.signOut()
        
        router?.showLoginViewController()
    }
}

// MARK: - IProfileInteractorOutput

extension ProfilePresenter: IProfileInteractorOutput {
    func fetchCurrentUserSuccess(_ user: User) {
        viewController?.setUser(user)
        viewController?.reloadData()
        
        if let identifier = user.identifier {
            interactor?.fetchPosts(identifier: identifier)
        }
    }
    
    func fetchCurrentUserFailure() {
        
    }
    
    func fetchPostsSuccess(_ posts: [Post]) {
        viewController?.setPosts(posts)
        viewController?.reloadData()
    }
    
    func fetchPostsFailure() {
        
    }
}
