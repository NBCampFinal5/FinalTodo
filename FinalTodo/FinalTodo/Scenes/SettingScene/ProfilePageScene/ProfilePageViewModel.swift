//
//  ProfilePageViewModel.swift
//  FinalTodo
//
//  Created by SR on 2023/10/23.
//

import UIKit

class ProfilePageViewModel {
    var idLabelText: String = "eagle5@gmail.com" // 사용자 아이디(이메일) 받아오기 (파이어베이스)
    
    let nickNameLabelTitle = "닉네임"
    var nickNameLabelPlaceholder: String = "" // 사용자 닉네임 받아오기 (파이어베이스)
    var nickNameLabelUserInput: String = ""
    
    let passwordLabelTitle = "비밀번호"
    var passwordLabelPlaceholder: String = "" // 사용자 비밀번호 받아오기 (파이어베이스)
    var passwordLabelUserInput: String = ""

    let passwordCheckLabelTitle = "비밀번호 확인"
    var passwordCheckLabelPlaceholder: String = "" // 사용자 비밀번호 받아오기 (파이어베이스)
    var passwordCheckLabelUserInput: String = ""
    
    let editButtonTitle = "수정"
    var editButtonColor: String = "" // 사용자 지정 테마컬러 받아오기 (파이어베이스)
    
    let allertLabelText = "비밀번호가 일치하지 않습니다!"
     
    var allertLabelTextIsHidden: Bool = true // 텍스트필드 isHidden 불값
}
