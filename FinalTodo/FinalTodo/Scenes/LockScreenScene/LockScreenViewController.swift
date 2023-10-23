//
//  LockScreenViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit
import SnapKit

class LockScreenViewController: LockController {
    
    
    private let viewModel: LockScreenViewModel
    
    init(rootViewController: UIViewController) {
        self.viewModel = LockScreenViewModel(rootViewController: rootViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[LockScreenViewController]: deinit")
    }

}
extension LockScreenViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setUp()
        bind()
        lockScreenView.titleLabel.text = "암호 입력"
    }
}

extension LockScreenViewController {
    //  MARK: - Bind
    override func bind() {
        userInPutPassword.bind { [weak self] inputData in
            guard let self = self else { return }
            lockScreenView.passwordInfoLabel.alpha = 0
            lockScreenView.passwordCollectionView.reloadData()
            if inputData.count == lockScreenPassword.count {
                if inputData == lockScreenPassword {
                    print("[LockScreenViewController]: 비밀번호 일치")
                    let rootView = viewModel.rootViewController
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: rootView, animated: false)
                } else {
                    print("[LockScreenViewController]: 비밀번호 불일치")
                    showPasswordMissMatch(type: .mismatch)
                }
            }
        }
    }
}
