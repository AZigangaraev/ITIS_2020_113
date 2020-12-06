//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {
    
    var userId: Int?
    private var dataTask: URLSessionDataTask?
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    override func viewDidLoad() {
        loadUser()
    }
    
    let userService = UserService(responseQueue: .main)
    var user: User? {
        didSet {
            loadImage()
            nameLabel.text = "\(String(describing: user!.firstName)) \(String(describing: user!.lastName))"
            emailLabel.text = user!.email
        }
    }
    
    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
    
    private func loadUser() {
        guard let userId = userId else {
            return
        }
        userService.loadUser(id: userId) { result in
            switch result {
            case .success(let user):
                self.user = user.user
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func loadImage() {
        guard let user = user else { return }
        let url = user.avatar
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.avatarImageView.image = image
                }
            }
        }
        dataTask.resume()
    }
}
