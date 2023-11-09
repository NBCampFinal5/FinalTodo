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
    func didCompleteTimeSetting(time: Date) // 시간 설정 완료 시 호출될 메서드
}

protocol LocationSettingDelegate: AnyObject {
    func didCompleteLocationSetting(location: String)
    func didResetLocationSetting()
}

protocol DateSettingDelegate: AnyObject {
    func didCompleteDateSetting(date: Date) // 날짜 설정이 완료될 때 호출될 메서드를 정의
    func didResetDateSetting()
}

protocol ButtonTappedViewDelegate: AnyObject {
    func didTapButton(button: UIButton)
}

protocol CommandLabelDelegate: AnyObject {
    func textFieldEditingChanged(_ textField: UITextField)
}

// 새 메모를 추가하거나 기존 메모를 편집할 때 호출되는 델리게이트 프로토콜
protocol AddMemoDelegate: AnyObject {
    func didAddMemo()
}


