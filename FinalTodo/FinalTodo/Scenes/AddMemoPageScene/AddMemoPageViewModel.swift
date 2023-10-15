//
//  AddMemoPageViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import UIKit

class AddMemoPageViewModel {
    let optionImageAry: [String] = [
        "날짜 설정",
        "알림 설정"
    ]
    
    var timeState: Observable<Bool> = Observable(false)
    var locateState: Observable<Bool> = Observable(false)
}
