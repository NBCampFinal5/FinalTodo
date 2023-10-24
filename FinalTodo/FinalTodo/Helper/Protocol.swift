//
//  Protocol.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import UIKit

protocol SettingCellDelegate: AnyObject {
    func didChangeSwitchState(_ cell: SettingCell, isOn: Bool)
}

protocol NotifySettingDelegate: AnyObject {
    func didCompleteNotifySetting() // 알림 설정 완료시 호출될 메서드
    func didResetNotifySetting() // 알림 설정 초기화시 호출될 메서드
}

protocol DateSettingDelegate: AnyObject {
    func didCompleteDateSetting(date: Date) // 날짜 설정이 완료될 때 호출될 메서드를 정의
    func didResetDateSetting()
}

protocol ButtonTappedViewDelegate: AnyObject {
    func didTapButton()
}

protocol CommandLabelDelegate: AnyObject {
    func textFieldEditingChanged(_ textField: UITextField)
}
