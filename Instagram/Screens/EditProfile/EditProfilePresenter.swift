//
//  EditProfilePresenter.swift
//  Instagram
//
//  Created by Admin on 06.03.2021.
//

import UIKit

final class EditProfilePresenter {
    weak var view: EditProfileViewControllerProtocol?
    weak var coordinator: EditProfileCoordinatorProtocol?
    
    var editProfileService: EditProfileServiceProtocol?
    
    var user: User?
    
    private var currentUsername: String?
}

// MARK: - EditProfileView Output

extension EditProfilePresenter: EditProfileViewControllerOutputProtocol {
    func viewDidLoad() {
        guard let user = user else { return }
        
        currentUsername = user.username
        view?.setUser(user)
    }
    
    func didTapCloseButton() {
        coordinator?.closeEditProfileViewController()
    }
    
    func didTapEditButton(
        fullName: String?,
        username: String,
        website: String?,
        bio: String?,
        profileImage: UIImage?
    ) {
        guard let currentUsername = currentUsername else { return }
        
        view?.showLoadingView()
        
        editProfileService?.updateUser(
            currentUsername: currentUsername,
            fullName: fullName,
            username: username,
            website: website,
            bio: bio,
            profileImage: profileImage) { [weak self] result in
            self?.view?.hideLoadingView {
                switch result {
                case .usernameExist:
                    self?.view?.showAlreadyInUseUsernameAlert()
                case .success:
                    self?.coordinator?.closeEditProfileViewController()
                case .failure:
                    self?.view?.showUnknownAlert()
                }
            }
        }
    }
    
    func didTapUsernameTextField() {
        guard
            let username = user?.username,
            let currentUsername = currentUsername
        else {
            return
        }
        
        coordinator?.showEditProfileUsernameViewController(
            username: username,
            currentUsername: currentUsername,
            delegate: self)
    }
    
    func didTapBioTextField() {
        coordinator?.showEditProfileBioViewController(bio: user?.bio, delegate: self)
    }
}

// MARK: - EditProfileUsernamePresenterDelegate

extension EditProfilePresenter: EditProfileUsernamePresenterDelegate {
    func editProfileUsernamePresenter(
        _ editProfileUsernamePresenter: EditProfileUsernamePresenter,
        didChangeUsername username: String
    ) {
        view?.username = username
    }
}

// MARK: - EditProfileBioPresenterDelegate

extension EditProfilePresenter: EditProfileBioPresenterDelegate {
    func editProfileBioPresenter(_ editProfileBioPresenter: EditProfileBioPresenter, didChangeBio bio: String?) {        
        view?.bio = bio
    }
}
