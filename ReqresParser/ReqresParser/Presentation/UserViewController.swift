//
//  UserViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class UserViewController: UIViewController {

    let userService = UserService(responseQueue: .main)

    var userId: Int?

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
        guard let userId = self.userId else {
            return
        }

        userService.loadUser(id: userId) { [weak self] result in
            switch result {
            case .success(let userData):
                let user = userData.user
                self?.avatarImageView.load(url: user.avatar)
                self?.emailLabel.text = user.email
                self?.nameLabel.text = user.firstName
            case .failure(let error):
                print("Failure")
                print(error)
            }
        }

    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
