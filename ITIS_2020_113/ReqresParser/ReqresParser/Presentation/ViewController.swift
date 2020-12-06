//
//  ViewController.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userService = UserService(responseQueue: .main)
    let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadUsers()
        
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    // MARK: - Logic

    private func loadUsers() {
        userService.loadUsers(page: 0) { [self] result in
            switch result {
                case .success(let users):
                    self.users = users.users
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
    }

    // MARK: - Table view

    private var users: [User] = []
    private let cellIdentifier = "Cell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller = storyboard.map(UserViewController.from) else { return }
        controller.userId = users[indexPath.row].id
        show(controller, sender: nil)
    }
}

