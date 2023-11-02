//
//  MemoViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

//import Foundation
import UIKit

class MemoViewModel {
    let optionImageAry: [String] = [
        "날짜 설정",
        "알림 설정"
    ]
    
    var isPin: Observable<Bool> = Observable(false)
}
