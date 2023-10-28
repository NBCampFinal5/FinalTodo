//
//  LockController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/23/23.
//

import Foundation
import UIKit

class LockController: UIViewController {
    
    enum PasswordShowType {
        case mismatch
        case different
    }
    
    let lockScreenView = LockScreenView()
    
    let userDefaultsManager = UserDefaultsManager()
    
    lazy var lockScreenPassword = userDefaultsManager.getPassword()
    
    let failCount: Observable<Int> = Observable(0)
    
    let userInPutPassword: Observable<String> = Observable("")
    
    let passwordCollectionviewSpacing = Constant.defaultPadding
    
    let passwordCollectionviewItemSize: CGSize = .init(
        width: Constant.screenWidth * 0.05,
        height: Constant.screenWidth * 0.05
    )
    
    let passwordLength:CGFloat = 4
    
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

    deinit {
        print("[LockScreenViewController]: deinit")
    }
}

extension LockController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

extension LockController {

    // MARK: - Bind
    
    @objc func bind() {
        userInPutPassword.bind { [weak self] inputData in
            guard let self = self else { return }
            lockScreenView.passwordInfoLabel.alpha = 0
            lockScreenView.passwordCollectionView.reloadData()
        }
    }
    // MARK: - SetUp

    func setUp() {
        view.backgroundColor = .systemBackground
        view.addSubview(lockScreenView)
        lockScreenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lockScreenView.numsCollectionView.delegate = self
        lockScreenView.numsCollectionView.dataSource = self
        lockScreenView.passwordCollectionView.delegate = self
        lockScreenView.passwordCollectionView.dataSource = self
    }
    
    // MARK: - Method
    
    func showPasswordMissMatch(type:PasswordShowType) {
        
        userInPutPassword.value = ""
        failCount.value += 1
        print("FailCount:",failCount.value)
        switch type {
        case .different:
            lockScreenView.passwordInfoLabel.text = "비밀번호가 일치하지 않습니다"
        case .mismatch:
            lockScreenView.passwordInfoLabel.text = "비밀번호를 확인해 주세요"
        }
        UIView.animate(withDuration: 1) {
            self.lockScreenView.passwordInfoLabel.alpha = 1
        }
        lockScreenView.passwordCollectionView.shake()
    }
}

extension LockController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - extension UICollectionViewDelegate, UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == lockScreenView.passwordCollectionView {
            return Int(passwordLength)
        } else {
            return numPadComposition.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == lockScreenView.passwordCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenPasswordCollectionViewCell.identifier, for: indexPath) as! LockScreenPasswordCollectionViewCell
            if indexPath.row < userInPutPassword.value.count {
                cell.bind(toggle: true)
            } else {
                cell.bind(toggle: false)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenNumCollectionViewCell.identifier, for: indexPath) as! LockScreenNumCollectionViewCell
            cell.bind(title: numPadComposition[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == lockScreenView.numsCollectionView {
            switch numPadComposition[indexPath.row] {
            case "AC":
                userInPutPassword.value = ""
            case "C":
                if userInPutPassword.value.count != 0 {
                    let _ = userInPutPassword.value.popLast()
                }
            default:
                if Int(passwordLength) > userInPutPassword.value.count {
                    userInPutPassword.value += numPadComposition[indexPath.row]
                }
            }
        }
    }
}

extension LockController: UICollectionViewDelegateFlowLayout {

    // MARK: - extension UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == lockScreenView.passwordCollectionView {
            
            let totalCellWidth = passwordCollectionviewItemSize.width * passwordLength
            let totalSpacingWidth = passwordCollectionviewSpacing * (passwordLength - 1)
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
