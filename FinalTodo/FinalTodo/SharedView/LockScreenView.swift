//
//  LockScreenView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/23/23.
//

import UIKit

class LockScreenView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var passwordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: Constant.screenWidth * 0.05, height: Constant.screenWidth * 0.05)
        flowLayout.minimumLineSpacing = Constant.defaultPadding
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .red
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    lazy var numsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing = Constant.defaultPadding
        flowLayout.minimumLineSpacing = spacing
        
        let width = (Constant.screenWidth - (Constant.defaultPadding * 6) - (spacing * 4)) / 3
        flowLayout.itemSize = .init(width: width, height: width)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension LockScreenView {
    // MARK: - SetUp
    
    func setUp() {
        setUpPasswordLabel()
        setUpPasswordCollectionView()
        setUpPasswordInfoLabel()
        setUpNumsCollectionView()
    }
    
    func setUpPasswordLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.15)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpPasswordInfoLabel() {
        self.addSubview(passwordInfoLabel)
        passwordInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCollectionView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpPasswordCollectionView() {
        self.addSubview(passwordCollectionView)
        passwordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constant.screenWidth * 0.05)
        }
        passwordCollectionView.register(
            LockScreenPasswordCollectionViewCell.self, forCellWithReuseIdentifier: LockScreenPasswordCollectionViewCell.identifier
        )
    }
    
    func setUpNumsCollectionView() {
        self.addSubview(numsCollectionView)
        numsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(passwordCollectionView.snp.bottom).offset(Constant.screenHeight * 0.1)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding * 3)
            make.bottom.equalToSuperview()
        }
        numsCollectionView.register(
            LockScreenNumCollectionViewCell.self, forCellWithReuseIdentifier: LockScreenNumCollectionViewCell.identifier
        )
    }
}
