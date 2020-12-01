//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {
    private let userService = UserService(responseQueue: .main)
    var userId: Int? {
        didSet {
            guard let userId = userId else { return }
            loadUser(withId: userId)
        }
    }

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
    
    private func loadUser(withId id: Int) {
        userService.loadUser(by: id) { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let userResponse):
                let user = userResponse.user
                self?.nameLabel.text = user.firstName + " " + user.lastName
                self?.emailLabel.text = user.email
                self?.avatarImageView.load(from: user.avatar)
            }
        }
    }
}
