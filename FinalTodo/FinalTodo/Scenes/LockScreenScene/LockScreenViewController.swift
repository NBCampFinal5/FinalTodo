//
//  LockScreenViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit
import SnapKit

class LockScreenViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }()
}

extension LockScreenViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
    }
}
