//
//  CommentsAssembly.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

enum CommentsAssembly {
    static func createCommentsViewController(userPost: UserPost) -> CommentsViewController {
        let viewController = CommentsViewController()
        
        let interactor = CommentsInteractor()
        let presenter = CommentsPresenter()
        let router = CommentsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.userPost = userPost
        
        return viewController
    }
}