//
//  LockScreenViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit
import SnapKit

class LockScreenViewController: UIViewController {
    
    private let numsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing = Constant.defaultPadding
        let width = (Constant.screenWidth - (Constant.defaultPadding * 2) - (spacing * 2)) / 3
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = .init(width: width, height: width)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
}

extension LockScreenViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension LockScreenViewController {
    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        view.addSubview(numsCollectionView)
        numsCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
        numsCollectionView.delegate = self
        numsCollectionView.dataSource = self
        numsCollectionView.register(LockScreenNumCollectionViewCell.self, forCellWithReuseIdentifier: LockScreenNumCollectionViewCell.identifier)
    }
}

extension LockScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenNumCollectionViewCell.identifier, for: indexPath) as! LockScreenNumCollectionViewCell
        
        return cell
    }
    
    
}
