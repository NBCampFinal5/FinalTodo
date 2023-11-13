//
//  BasicViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 11/13/23.
//

import UIKit
import SnapKit

//제네릭 사용 버전
class BasicViewController<T,V>: UIViewController {
    
    var viewModel: T?
    
    var customView: V!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BasicViewController: ViewModelInjectable {
    func injectViewModel(_ viewModelType: T) {
        self.viewModel = viewModelType
    }
}

extension BasicViewController: ViewInjectable {
    func injectView(_ viewType: V) {
        self.customView = viewType
    }
}

//class BasicViewController: UIViewController {
//    
//    var viewModel: AnyObject.Type?
//    
//    var customView: AnyObject.Type!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
//
//extension BasicViewController: ViewModelInjectable {
//    func injectViewModel(_ viewModelType: AnyObject.Type) {
//        self.viewModel = viewModel as? ViewModelType
//        self.viewModel = viewModelType
//    }
//}
//
//extension BasicViewController: ViewInjectable {
//    func injectView(_ viewType: AnyObject.Type) {
//        self.customView = customView as? ViewType
//        self.customView = viewType
//    }
//}
