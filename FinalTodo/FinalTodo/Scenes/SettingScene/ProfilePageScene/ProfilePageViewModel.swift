//
//  ProfilePageViewModel.swift
//  FinalTodo
//
//  Created by SR on 2023/10/23.
//

import UIKit

class ProfilePageViewModel {
    private let manager = CoreDataManager.shared

    var userId: String = "userId"
    private var userFolders: [FolderData] = []
    private var userFoldersMemos: [MemoData] = []
    private var userPoint: Int32 = 0
    private var userThemeColor = ""

    var userNickName: String = "user"
    var rewardNickName: String = "gini"
    var giniImage: String = "gini1"

    func fetchUserData(completion: @escaping () -> Void) {
        userId = manager.getUser().id
        userFolders = manager.getUser().folders
        userFoldersMemos = manager.getUser().memos
        userThemeColor = manager.getUser().themeColor

        userPoint = manager.getUser().rewardPoint
        userNickName = manager.getUser().nickName
        rewardNickName = manager.getUser().rewardName

//        fetchGiniImage(point: userPoint)
        print("@@ 유저 패치!")
        completion()
    }

//    private func fetchGiniImage(point: Int32) {
//        if userPoint >= 30 {
//            giniImage = "gini4"
//        } else if userPoint >= 20 {
//            giniImage = "gini3"
//        } else if userPoint >= 10 {
//            giniImage = "gini2"
//        } else {
//            giniImage = "gini1"
//        }
//    }

    // 프로필 이미지 계산용
    lazy var score = manager.getUser().rewardPoint

    enum EditType {
        case userNickName
        case rewardNickName
    }

    func updateNickName(type: EditType, newName: String) {
        switch type {
        case .userNickName:
            let userWithNewNickName = UserData(id: userId, nickName: newName, folders: userFolders, memos: userFoldersMemos, rewardPoint: userPoint, rewardName: rewardNickName, themeColor: userThemeColor)
            manager.updateUser(targetId: userId, newUser: userWithNewNickName) {
                print("@@ 유저 닉네님 업데이트:", userWithNewNickName.nickName)
            }

        case .rewardNickName:
            let rewardWithNewNickName = UserData(id: userId, nickName: userNickName, folders: userFolders, memos: userFoldersMemos, rewardPoint: userPoint, rewardName: newName, themeColor: userThemeColor)
            manager.updateUser(targetId: userId, newUser: rewardWithNewNickName) {
                print("@@ 리워드 닉네임 업데이트:", rewardWithNewNickName.rewardName)
            }
        }
    }
}
