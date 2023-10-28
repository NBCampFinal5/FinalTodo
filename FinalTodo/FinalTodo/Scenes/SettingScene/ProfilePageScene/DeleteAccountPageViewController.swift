//
//  DeleteAccountPageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/26.
//

import UIKit

class DeleteAccountPageViewController: UIViewController {
    private lazy var giniImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gini1")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var giniChatLabel: UILabel = {
        let label = UILabel()
        label.text = "정말... 계정 삭제하실 건가요?"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    private lazy var allertLabel: UILabel = {
        let label = UILabel()
        label.text = "*주의*\n계정 삭제 시 \n폴더·메모·기니피그 데이터가 함께 삭제됩니다."
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

private extension DeleteAccountPageViewController {
    func setUp() {
        title = "계정 삭제"
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor

        deleteAccountButton.addTarget(self, action: #selector(DidTapDeleteAccountButton), for: .touchUpInside)

        view.addSubview(giniChatLabel)
        view.addSubview(giniImageView)
        view.addSubview(allertLabel)
        view.addSubview(deleteAccountButton)

        giniChatLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            make.centerX.equalToSuperview()
        }

        giniImageView.snp.makeConstraints { make in
            make.top.equalTo(giniChatLabel.snp.bottom).offset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.45)
            make.centerX.equalToSuperview()
        }

        allertLabel.snp.makeConstraints { make in
            make.top.equalTo(giniImageView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            make.centerX.equalToSuperview()
        }
    }

    @objc
    func DidTapDeleteAccountButton() {
        let alert = UIAlertController(title: "계정 삭제", message: "사용자 계정을 영구 삭제합니다.", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            self?.deleteAccount()
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func deleteAccount() {
        // 데이터베이스 유저 정보 삭제 로직 추가 필요

        let signInVC = SignInPageViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: signInVC, animated: true)

        print("계정 삭제 완료")
    }
}
