//
//  RewardPageViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 11/3/23.
//

import Foundation

class RewardPageViewModel {
    
    let coredataManager = CoreDataManager.shared
    let progressRadius: CGFloat = Constant.screenWidth * 0.03
    let progressLineWidth: CGFloat = 6
    lazy var score = coredataManager.getUser().rewardPoint
    lazy var titleText = "어쩌구저쩌구님은\n지금까지 \(score)개의\n메모를 작성했어요."
    lazy var infoText = "\(10 - Int((score.description).suffix(1))!)개의 메모를 작성하면 다음 기니를 만날 수 있어요"
}
