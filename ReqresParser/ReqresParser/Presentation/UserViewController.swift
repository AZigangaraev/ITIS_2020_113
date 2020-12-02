//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {
    let userService = UserService(responseQueue: .main)
    var user: User? {
        didSet {
            nameLabel.text = "\(String(describing: user!.lastName)) \(String(describing: user!.firstName))"
            emailLabel.text = user!.email
            loadImage()
        }
    }
    
    var userId: Int?

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        loadSigleUser()
    }
    
    // MARK: - Get user data
    private func loadSigleUser() {
        guard let userId = userId else {
            return
        }
        userService.loadSingleUser(id: userId) { result in
            switch result {
            case .success(let user):
                self.user = user.user
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    // MARK: - Parse user image
    
    private var dataTask: URLSessionDataTask?
    
    private func loadImage() {
        guard let user = user else { return }
        let url = user.avatar

        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.avatarImageView.image = image
                }
            }
        }
        dataTask?.resume()
    }
}
