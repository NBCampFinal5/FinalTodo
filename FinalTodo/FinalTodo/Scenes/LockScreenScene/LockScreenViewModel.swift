//
//  LockScreenViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/19/23.
//

import Foundation
import UIKit

class LockScreenViewModel {
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    let rootViewController: UIViewController
    
    deinit {
        print("LockScreenViewModel deinit")
    }
}






