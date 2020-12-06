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
    private var dataTask: URLSessionDataTask?
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    private func loadUser() {
        guard let userId = userId else {return}
        userService.loadUser(id: userId) { [self] result in
            switch result {
                case .success(let user):
                    nameLabel.text = "\(user.user.firstName) \(user.user.lastName)"
                    emailLabel.text = user.user.email
                    loadImage(url: user.user.avatar)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func loadImage(url: URL) {
            dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self.avatarImageView.image = image
                    }
                }
            }
            dataTask?.resume()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
    }
    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
}
