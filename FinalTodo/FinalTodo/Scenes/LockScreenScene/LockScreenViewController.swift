//
//  LockScreenViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit
import SnapKit

class LockScreenViewController: UIViewController {
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "암호 입력"
        return label
    }()
    
    private let passwordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .green
        return view
    }()
    
    private let numsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing = Constant.defaultPadding * 2
        let width = (Constant.screenWidth - (Constant.defaultPadding * 6) - (spacing * 2)) / 3
        flowLayout.minimumLineSpacing = spacing / 2
        flowLayout.itemSize = .init(width: width, height: width)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    private let viewModel = LockScreenViewModel()
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
        setUpPasswordLabel()
        setUpPasswordCollectionView()
        setUpNumsCollectionView()
    }
    
    func setUpPasswordLabel() {
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.15)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpPasswordCollectionView() {
        view.addSubview(passwordCollectionView)
        passwordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    func setUpNumsCollectionView() {
        numsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(passwordCollectionView.snp.bottom).offset(Constant.screenHeight * 0.1)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding * 3)
            make.bottom.equalToSuperview()
        }
        numsCollectionView.delegate = self
        numsCollectionView.dataSource = self
        numsCollectionView.register(LockScreenNumCollectionViewCell.self, forCellWithReuseIdentifier: LockScreenNumCollectionViewCell.identifier)
    }
}

extension LockScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == passwordCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenNumCollectionViewCell.identifier, for: indexPath) as! LockScreenNumCollectionViewCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenNumCollectionViewCell.identifier, for: indexPath) as! LockScreenNumCollectionViewCell
            
            return cell
        }
    }
}
