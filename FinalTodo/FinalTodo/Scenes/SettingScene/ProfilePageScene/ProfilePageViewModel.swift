//
//  ProfilePageViewModel.swift
//  FinalTodo
//
//  Created by SR on 2023/10/23.
//

import UIKit

class ProfilePageViewModel {
//    let firebaseManager = FirebaseManager()
    
    var idLabelText: String = "eagle5@gmail.com" // 사용자 아이디(이메일) 받아오기
    
    var nickNameLabelPlaceholder: String = "짱짱독수리" // 사용자 닉네임 받아오기
    var nickNameLabelUserInput: String = ""
    
    var passwordLabelPlaceholder: String = "******" // 사용자 비밀번호 받아오기
    var passwordLabelUserInput: String = ""

    var passwordCheckLabelPlaceholder: String = "******" // 사용자 비밀번호 받아오기
    var passwordCheckLabelUserInput: String = ""
    
    var editButtonColor: Int = 1 // 사용자 지정 테마컬러 받아오기
    
    var allertLabelTextIsHidden: Bool = true // 텍스트필드 isHidden 불값 -> 기본값은 true, passwordLabelUserInput사용자 입력값, passwordCheckLabelUserInput 사용자 입력값이 다를 때 isHidden = false
    
    func fetchDataFromFirebase() {
//        firebaseManager.fetchUserData(email: idLabelText) { [weak self] user in
////            self?.idLabelText = user.id
//            self?.nickNameLabelPlaceholder = user.nickName
////            self?.passwordLabelPlaceholder = user.password // User 모델에 비밀번호 추가 필요????
////            self?.passwordCheckLabelPlaceholder = user.password
//            self?.editButtonColor = user.themeColor
//        }
    }
    
    func updateUserData() {
//        firebaseManager.updateUserData(email: idLabelText) {
//            print("업데이트 파이어베이스 유저데이터")
//        }
    }
}
