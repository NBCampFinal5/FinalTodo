//
//  ProfilePageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import SnapKit
import UIKit

class ProfilePageViewController: UIViewController {
    let viewModel = ProfilePageViewModel()

    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.idLabelText // 뷰모델에서 받을 내용
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()

    lazy var nickNameLabel: CommandLabelView = {
        let title = viewModel.nickNameLabelTitle // 뷰모델에서 받을 내용
        let placeholder = viewModel.nickNameLabelPlaceholder // 뷰모델에서 받을 내용
        let view = CommandLabelView(title: title, placeholder: placeholder)
        return view
    }()

    lazy var passwordNameLabel: CommandLabelView = {
        let title = viewModel.passwordLabelTitle // 뷰모델에서 받을 내용
        let placeholder = viewModel.passwordLabelPlaceholder // 뷰모델에서 받을 내용
        let view = CommandLabelView(title: title, placeholder: placeholder)
        return view
    }()

    lazy var passwordCheckLabel: CommandLabelView = {
        let title = viewModel.passwordCheckLabelTitle // 뷰모델에서 받을 내용
        let placeholder = viewModel.passwordCheckLabelPlaceholder // 뷰모델에서 받을 내용
        let view = CommandLabelView(title: title, placeholder: placeholder)
        return view
    }()

    lazy var editButton: ButtonTappedView = {
        let title = viewModel.editButtonTitle // 뷰모델에서 받을 내용
        let view = ButtonTappedView(title: title) // color: "viewModel.editButtonColor" 버튼 색깔도 받아야 할 것 같아요
        return view
    }()

    lazy var allertLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다!" // 뷰모델에서 받을 내용
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .red
        label.isHidden = viewModel.allertLabelTextIsHidden // 뷰모델에서 받을 내용
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
}

private extension ProfilePageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        title = "프로필"

        view.addSubview(idLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(nickNameLabel)
        stackView.addArrangedSubview(passwordNameLabel)
        stackView.addArrangedSubview(passwordCheckLabel)
        stackView.addArrangedSubview(editButton)
        view.addSubview(allertLabel)

        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.15)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
            make.bottom.equalToSuperview().inset(Constant.screenHeight * 0.15)
            make.left.right.equalToSuperview()
        }

        allertLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).inset(Constant.defaultPadding)
            make.centerX.equalTo(passwordCheckLabel.snp.centerX)
        }
    }

    func bind() {}
}
