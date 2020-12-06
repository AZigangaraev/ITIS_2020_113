//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {
    var userId: Int?
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    private let userService = UserService(responseQueue: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        guard let id = userId else { return }
        userService.loadUser(id: id) { [self] result in
            switch result {
            case .success(let userResponse):
                let user = userResponse.user
                nameLabel.text = "\(user.firstName) \(user.lastName)"
                emailLabel.text = user.email
                loadImage(from: user.avatar)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.avatarImageView.image = image
                }
            }
        }.resume()
    }
    
    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
}
