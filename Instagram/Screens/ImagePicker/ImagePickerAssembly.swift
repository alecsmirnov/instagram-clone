//
//  ImagePickerAssembly.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

enum ImagePickerAssembly {
    static func createImagePickerNavigationController(
        coordinator: ImagePickerCoordinatorProtocol? = nil
    ) -> UINavigationController {
        return UINavigationController(rootViewController: createImagePickerViewController(coordinator: coordinator))
    }
    
    private static func createImagePickerViewController(
        coordinator: ImagePickerCoordinatorProtocol?
    ) -> ImagePickerViewController {
        let viewController = ImagePickerViewController()
        let presenter = ImagePickerPresenter()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.coordinator = coordinator
        
        presenter.imagesService = LocalImagesService()
        
        return viewController
    }
}
