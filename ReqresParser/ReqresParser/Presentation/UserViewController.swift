//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {
    var userId: Int?
    let userService = UserService(responseQueue: .main)
    var user: User?

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
    
    func loadUser() {
        guard let id = userId else { return  }
        userService.loadUser(id: id) { [self] result in
            switch result {
            case .success(let readedUser):
                user = readedUser.user
                fillUserFields()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fillUserFields() {
        guard let user = user else { return  }
        nameLabel.text = user.firstName + " " + user.lastName
        emailLabel.text = user.email
        setAvatar()
    }
    
    func setAvatar() {
        guard let url = user?.avatar else { return }
        
        userService.getAvatar(url: url) { result in
            switch result {
                case .success(let data) :
                    self.avatarImageView.image = UIImage(data: data)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
