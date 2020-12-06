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
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
    }
    
    private func loadUser() {
        userService.loadUser(id: userId!) { [self] result in
            switch result {
                case .success(let userResponse):
                    self.nameLabel.text = userResponse.user.firstName + " " + userResponse.user.lastName
                    self.emailLabel.text = userResponse.user.email
                    userService.loadUserImage(url: userResponse.user.avatar) { (result) in
                        switch result{
                        case .success(let data):
                            self.avatarImageView.image = UIImage(data: data)
                        case.failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
