//
//  LockScreenViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/19/23.
//

import Foundation
import UIKit

class LockScreenViewModel {
    
//    init(rootViewController: UIViewController) {
//        self.rootViewController = rootViewController
//    }
//    
    init(rootViewController: UIViewController, targetViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.targetViewController = targetViewController
    }
    let lockScreenPassword = "123456"
    
    let userInPutPassword: Observable<String> = Observable("")
    
    let passwordCollectionviewSpacing = Constant.defaultPadding
    
    let passwordCollectionviewItemSize: CGSize = .init(
        width: Constant.screenWidth * 0.05,
        height: Constant.screenWidth * 0.05
    )
    
    let rootViewController: UIViewController
    
    let targetViewController: UIViewController
    
    let numPadComposition = [
        "1", "2", "3",
        "4", "5", "6",
        "7", "8", "9",
        "AC","0", "C"
    ]
    
    let numPadCollectionviewSpacing = Constant.defaultPadding * 2
    
    lazy var numPadCollectionviewItemSize: CGSize = .init(
        width: (Constant.screenWidth - (Constant.defaultPadding * 6) - (numPadCollectionviewSpacing * 2)) / 3,
        height: (Constant.screenWidth - (Constant.defaultPadding * 6) - (numPadCollectionviewSpacing * 2)) / 3
    )
}
