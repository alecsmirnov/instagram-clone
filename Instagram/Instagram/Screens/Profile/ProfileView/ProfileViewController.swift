//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol IProfileViewController: AnyObject {
    func setUser(_ user: User)
    func setUserStats(_ userStats: UserStats)
    func appendFirstPost(_ post: Post)
    func appendLastPost(_ post: Post)
    func removeAllPosts()
    
    func reloadData()
    
    func showEditButton()
    func showFollowButton()
    func showUnfollowButton()
}

final class ProfileViewController: CustomViewController<ProfileView> {
    // MARK: Properties
    
    var presenter: IProfilePresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        presenter?.viewDidLoad()
        
        setupAppearance()
    }
}

// MARK: - IProfileViewController

extension ProfileViewController: IProfileViewController {
    func setUser(_ user: User) {
        navigationItem.title = user.username
        
        customView?.setUser(user)
    }
    
    func setUserStats(_ userStats: UserStats) {
        customView?.setUserStats(userStats)
    }
    
    func appendFirstPost(_ post: Post) {
        customView?.appendFirstPost(post)
    }
    
    func appendLastPost(_ post: Post) {
        customView?.appendLastPost(post)
    }
    
    func removeAllPosts() {
        customView?.removeAllPosts()
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func showEditButton() {
        customView?.editFollowButtonState = .edit
    }
    
    func showFollowButton() {
        customView?.editFollowButtonState = .follow
    }
    
    func showUnfollowButton() {
        customView?.editFollowButtonState = .unfollow
    }
}

// MARK: - Appearance

private extension ProfileViewController {
    func setupAppearance() {
        customizeBackButton()
        setupMenuButton()
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setupMenuButton() {
        let menuBarButtonItem = UIBarButtonItem(
            //image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal),
            image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didPressMenuButton))
        
        navigationItem.rightBarButtonItem = menuBarButtonItem
    }
    
    @objc func didPressMenuButton() {
        presenter?.didPressMenuButton()
    }
}

// MARK: - ProfileViewDelegate

extension ProfileViewController: ProfileViewDelegate {
    func profileViewDidRequestPosts(_ profileView: ProfileView) {
        presenter?.didRequestPosts()
    }
    
    func profileViewDidPressFollowersButton(_ profileView: ProfileView) {
        presenter?.didPressFollowersButton()
    }
    
    func profileViewDidPressFollowingButton(_ profileView: ProfileView) {
        presenter?.didPressFollowingButton()
    }
    
    func profileViewDidPressEditButton(_ profileView: ProfileView) {
        presenter?.didPressEditButton()
    }
    
    func profileViewDidPressFollowButton(_ profileView: ProfileView) {
        presenter?.didPressFollowButton()
    }
    
    func profileViewDidPressUnfollowButton(_ profileView: ProfileView) {        
        presenter?.didPressUnfollowButton()
    }
    
    func profileViewDidPressGridButton(_ profileView: ProfileView) {
        presenter?.didPressGridButton()
    }
    
    func profileViewDidPressBookmarkButton(_ profileView: ProfileView) {
        presenter?.didPressBookmarkButton()
    }
    
    func profileView(_ profileView: ProfileView, didSelectPost post: Post) {
        
    }
}