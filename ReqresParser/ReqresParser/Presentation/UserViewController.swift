//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {
    
    weak var userService: UserService?
    var userId: Int?

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }

    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }

    private func loadUser() {
        guard let userId = userId, let userService = userService else { return }
        userService.loadUser(userId: userId) { [self] result in
            switch result {
            case .success(let userData):
                let user = userData.user
                nameLabel.text = "\(user.firstName) \(user.lastName)"
                emailLabel.text = user.email
                userService.loadImageOfUser(user: user) { [self] result in
                    switch result {
                    case .success(let data):
                        self.avatarImageView.image = UIImage(data: data)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
