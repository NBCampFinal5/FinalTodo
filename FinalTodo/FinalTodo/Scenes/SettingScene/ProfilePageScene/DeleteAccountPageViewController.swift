//
//  DeleteAccountPageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/26.
//

import UIKit
import FirebaseAuth

class DeleteAccountPageViewController: UIViewController {
    private lazy var giniChatLabel: UILabel = {
        let label = UILabel()
        label.text = "정말... 계정 삭제하실 건가요?"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.numberOfLines = 0

        label.layer.masksToBounds = true
        return label
    }()

    private lazy var allertLabel: UILabel = {
        let label = UILabel()
        label.text = "계정 삭제 시 데이터가\n 모두 삭제되니 주의해 주세요."
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var giniImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gini1")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 2
        return button
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
        navigationItem.title = "계정 삭제"
        view.backgroundColor = .systemBackground

        deleteAccountButton.addTarget(self, action: #selector(DidTapDeleteAccountButton), for: .touchUpInside)

        view.addSubview(giniChatLabel)
        view.addSubview(giniImageView)
        view.addSubview(allertLabel)
        view.addSubview(deleteAccountButton)

        giniChatLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.15)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.04)
        }

        allertLabel.snp.makeConstraints { make in
            make.top.equalTo(giniChatLabel.snp.bottom).offset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
        }

        giniImageView.snp.makeConstraints { make in
            make.top.equalTo(allertLabel.snp.bottom).offset(Constant.defaultPadding)
            make.width.equalTo(Constant.screenWidth * 0.4)
            make.height.equalTo(Constant.screenHeight * 0.3)
            make.centerX.equalToSuperview()
        }

        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding * 2)
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
        guard let email = Auth.auth().currentUser?.email else {
            print("Email is not available.")
            return
        }
        
        let password = "qwer1234!"

        FirebaseDBManager.shared.reauthenticateUser(email: email, password: password) { success, error in
            if let error = error {
                print("Reauthentication failed with error: \(error.localizedDescription)")
                return
            }

            if success {
                FirebaseDBManager.shared.deleteUser { error in
                    if let error = error {
                        print("User deletion failed with error: \(error.localizedDescription)")
                    } else {
                        print("User Delete Success")
                        
                        DispatchQueue.main.async {
                            let signInVC = SignInPageViewController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(viewController: signInVC, animated: true)
                            print("계정 삭제 완료")
                        }
                    }
                }
            } else {
                print("Reauthentication failed. User could not be reauthenticated.")
            }
        }
    }
}
