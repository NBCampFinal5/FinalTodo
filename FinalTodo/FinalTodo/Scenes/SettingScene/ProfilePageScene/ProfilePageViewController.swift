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
        coreDataManagerTest()
    }
}

extension ProfilePageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        title = "프로필"
    }

    func coreDataManagerTest() {
        // 더미 유저 생성
        CoreDataManager.shared.createUser(id: "user1", nickName: "John", rewardPoint: 100, themeColor: 1) { user in
            if let createdUser = user {
                print("🟡::코어데이터 더미유저 생성:: \(createdUser.nickName), Reward Points: \(createdUser.rewardPoint), Theme Color: \(createdUser.themeColor)🟡")
            }
        }

        // 유저 정보 불러오기!!
        CoreDataManager.shared.fetchUser(byID: "user1") { fetchedUser in
            if let user = fetchedUser {
                print("🟡::코어데이터 더미유저 불러오기:: \(user.nickName), Reward Points: \(user.rewardPoint), Theme Color: \(user.themeColor)🟡")
            }
        }
    }
}
