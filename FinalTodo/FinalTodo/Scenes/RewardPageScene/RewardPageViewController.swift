//
//  RewardPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

class RewardPageViewController: UIViewController {

    private var viewModel = RewardPageViewModel()
    
    private let titleTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .title1)
        return view
    }()
    
    private let giniImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gini1")
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private lazy var progressContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var progressView: CircularProgressView = {
        let view = CircularProgressView(
            round: viewModel.progressRadius,
            lineWidth: viewModel.progressLineWidth,
            circleColor: UIColor.systemGray.cgColor,
            progressColor: UIColor.myPointColor.cgColor
        )
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Constant.defaultPadding / 2
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        return label
    }()
}

extension RewardPageViewController {
    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        navigationController?.configureBar()
        tabBarController?.configureBar()
        viewModel = RewardPageViewModel()
        if viewModel.coredataManager.getUser().rewardName == "" {
            let alert = UIAlertController(title: "기니의 이름을 만들어 주세요!", message: "기니의 이름은 수정이 가능합니다.", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "확인", style: .default) { [weak self]_ in
                guard let self = self else { return }
                guard let name = alert.textFields?[0].text else { return }
                var user = self.viewModel.coredataManager.getUser()
                user.rewardName = name
                viewModel.coredataManager.updateUser(targetId: user.id, newUser: user) {
                    self.viewWillAppear(true)
                }
                
            }
            alert.addTextField()
            alert.textFields?[0].placeholder = "2글자에서 6글자 사이로 입력해주세요."
            alert.addAction(yes)
            self.present(alert, animated: true)
        }
        setUpText()
        setUpImage()
    }
    
    override func viewDidLoad() {
        setUpNavigation()
        setUp()
        setUpText()
        setUpImage()
        print(#function)
    }
}

private extension RewardPageViewController {
    // MARK: - SetUp

    func setUpNavigation() {
        self.navigationItem.title = "나의 기니"
    }
    
    func setUp() {
        setUpTitleTextView()
        setUpGiniImageView()
        setUpStackView()
        setUpProgressBar()
        setUpInfoLabel()
    }
    
    func setUpTitleTextView() {
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
        }
    }
    
    func setUpGiniImageView() {
        view.addSubview(giniImageView)
        giniImageView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Constant.defaultPadding * 4)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constant.screenWidth / 2)
        }
    }
    
    func setUpStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(progressContainer)
        stackView.addArrangedSubview(nameLabel)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(giniImageView.snp.bottom).offset(Constant.defaultPadding * 2)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpProgressBar() {
        progressContainer.snp.makeConstraints { make in
            make.width.height.equalTo(
                (viewModel.progressRadius + (viewModel.progressLineWidth / 2)) * 2
            )
        }
        progressContainer.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setUpInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(Constant.defaultPadding * 2)
            make.centerX.equalToSuperview()
        }
    }
}

private extension RewardPageViewController {
    // MARK: - Method
    
    func setUpImage() {
        var scoreString = viewModel.score.description
        scoreString.removeLast()
        guard let value = Int(scoreString) else { return }
        giniImageView.image = UIImage(named: "gini\(value + 1)")
    }
    
    func setUpText() {
        titleTextView.text = viewModel.titleText
        infoLabel.text = viewModel.infoText
        nameLabel.text = viewModel.coredataManager.getUser().rewardName
        let value = CGFloat(Int(viewModel.score.description.suffix(1))!)
        progressView.progressAnimation(duration: 0.4, value: value / 10)
    }

}

