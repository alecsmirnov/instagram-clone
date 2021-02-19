//
//  HomeInteractor.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

protocol IHomeInteractor: AnyObject {
    func fetchUserPosts()
}

protocol IHomeInteractorOutput: AnyObject {
    func fetchUserPostSuccess(_ userPost: UserPost)
    func fetchUserPostFailure()
}

final class HomeInteractor {
    weak var presenter: IHomeInteractorOutput?
    
    private var userPostsObserver = [String: FirebaseObserver]()
}

// MARK: - IHomeInteractor

extension HomeInteractor: IHomeInteractor {    
    func fetchUserPosts() {
        guard let identifier = FirebaseAuthService.currentUserIdentifier else { return }
        
        observeUserPosts(identifier: identifier) { [self] result in
            switch result {
            case .success(let userPost):
                presenter?.fetchUserPostSuccess(userPost)
            case .failure(let error):
                presenter?.fetchUserPostFailure()
                
                print("Failed to fetch user post: \(error.localizedDescription)")
            }
        }
        
        FirebaseUserService.fetchFollowingUsersIdentifiers(identifier: identifier) { [self] result in
            switch result {
            case .success(let identifiers):
                identifiers.forEach { followingUserIdentifier in
                    observeUserPosts(identifier: followingUserIdentifier) { [self] result in
                        switch result {
                        case .success(let userPost):
                            presenter?.fetchUserPostSuccess(userPost)
                        case .failure(let error):
                            presenter?.fetchUserPostFailure()
                            
                            print("Failed to fetch following user post: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch following users identifiers: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Private Methods

private extension HomeInteractor {
    func observeUserPosts(identifier: String, completion: @escaping (Result<UserPost, Error>) -> Void) {
        FirebaseUserService.fetchUser(withIdentifier: identifier) { [self] result in
            switch result {
            case .success(let user):
                guard let identifier = user.identifier else { return }
                
                observePosts(identifier: identifier) { result in
                    switch result {
                    case .success(let post):
                        let userPost = UserPost(user: user, post: post)
                        
                        completion(.success(userPost))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func observePosts(identifier: String, completion: @escaping (Result<Post, Error>) -> Void) {
        userPostsObserver[identifier] = FirebasePostService.observePosts(identifier: identifier) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeUserObserver(identifier: String) {
        userPostsObserver[identifier] = nil
    }
}
