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
    
    var linkAvatar: URL!
    
   

    static func from(storyboard: UIStoryboard) -> UserViewController {
        storyboard.instantiateViewController(identifier: String(describing: UserViewController.self))
    }
    
    func setUp(name: String, email: String, avatar: URL){
        nameLabel.text = name
        emailLabel.text = email
        linkAvatar = avatar
        

        let dataTask2 = URLSession.shared.dataTask(with: linkAvatar) { data, response, error in
            if let error = error {
                print("Task failed with error: \(error)")
            } else if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                    self.avatarImageView.image = image
                    }
                }
            }
        }
        dataTask2.resume()
    }
    
    override func viewDidLoad() {
       
    }
}
