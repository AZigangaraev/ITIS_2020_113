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

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUser()
        
    }
    
    

    private func loadUser() {
     
        
        guard let userId = userId else {
            return
        }
        
        userService.loadUser(id: userId) { [weak self] (userResult) in
            switch userResult {
            case .success(let userModel):
                self?.nameLabel.text = userModel.user.firstName + " " + userModel.user.lastName
                self?.emailLabel.text = userModel.user.email
                self?.userService.loadImage(url: userModel.user.avatar, { (imageResult) in
                    guard case let .success(image) = imageResult else {
                        return
                    }
                    self?.avatarImageView.image = image
                })
            case .failure(let error):
                print(error)
                return
                
            }
        }
    }
    
    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
}
