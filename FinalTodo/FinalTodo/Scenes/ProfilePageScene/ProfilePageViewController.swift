//
//  ProfilePageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import UIKit

class ProfilePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension ProfilePageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        title = "프로필"
    }
}
