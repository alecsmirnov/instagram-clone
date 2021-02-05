//
//  SharePostAssembly.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

enum SharePostAssembly {
    static func createSharePostViewController(mediaFile: MediaFileType) -> SharePostViewController {
        let viewController = SharePostViewController()
        
        let interactor = SharePostInteractor()
        let presenter = SharePostPresenter()
        let router = SharePostRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.mediaFile = mediaFile
        
        return viewController
    }
}