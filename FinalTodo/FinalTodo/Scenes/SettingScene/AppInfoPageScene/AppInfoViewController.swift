//
//  AppInfoViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/31/23.
//

import SnapKit
import UIKit

class AppInfoViewController: UIViewController {
    private let viewModel = AppInfoViewModel()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "버전정보"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        return label
    }()
    
    private let appIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = .red
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let appInfoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "뭐할기니"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.appVersion
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .myPointColor
        return view
    }()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.text = "Developer"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var developerTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.text = viewModel.developer
        view.font = .preferredFont(forTextStyle: .caption1)
        view.textColor = .systemGray
        view.backgroundColor = .clear
        return view
    }()
}

extension AppInfoViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension AppInfoViewController {
    func setUp() {
        view.backgroundColor = .secondarySystemBackground
        setUpVersionLabel()
        setUpAppIconImageView()
        setUpAppInfoStackView()
        setUpDivider()
        setUpDeveloperLabel()
        setUpDeveloperTextView()
    }
    
    func setUpVersionLabel() {
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
        }
    }
    
    func setUpAppIconImageView() {
        view.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(Constant.defaultPadding)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            make.height.width.equalTo(Constant.screenWidth * 0.15)
        }
    }
    
    func setUpAppInfoStackView() {
        appInfoStackView.addArrangedSubview(appTitleLabel)
        appInfoStackView.addArrangedSubview(appVersionLabel)
        view.addSubview(appInfoStackView)
        appInfoStackView.snp.makeConstraints { make in
            make.left.equalTo(appIconImageView.snp.right).offset(Constant.defaultPadding)
            make.centerY.equalTo(appIconImageView.snp.centerY)
        }
    }
    
    func setUpDivider() {
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(1)
        }
    }
    
    func setUpDeveloperLabel() {
        view.addSubview(developerLabel)
        developerLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(Constant.defaultPadding)
            make.left.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    func setUpDeveloperTextView() {
        view.addSubview(developerTextView)
        developerTextView.snp.makeConstraints { make in
            make.top.equalTo(developerLabel.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.3)
        }
    }
}
