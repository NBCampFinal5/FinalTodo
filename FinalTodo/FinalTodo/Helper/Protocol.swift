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
