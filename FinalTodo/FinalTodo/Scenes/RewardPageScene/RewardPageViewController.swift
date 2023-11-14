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
        view.backgroundColor = .clear
        return view
    }()
    
    private let giniImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gini1")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private lazy var progressContainerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
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
    
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()
    
    private let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Constant.defaultPadding
        view.alignment = .center
        return view
    }()
    
    private let infoTextView: UITextView = {
        let view = UITextView()
        view.font = .preferredFont(forTextStyle: .body)
        view.isEditable = false
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        view.textColor = .secondaryLabel
        view.backgroundColor = .clear
        return view
    }()
}

extension RewardPageViewController {
    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.configureBar()
        tabBarController?.configureBar()
        viewModel = RewardPageViewModel()
        showAlert()
        setUpText()
        setUpImage()
    }
    
    override func viewDidLoad() {
        setUpNavigation()
        setUp()
        setUpText()
        setUpImage()
    }
}

private extension RewardPageViewController {
    // MARK: - SetUp

    func setUpNavigation() {
        navigationItem.title = "나의 기니"
    }
    
    func setUp() {
        setUpTitleTextView()
        setUpGiniImageView()
        setUpNameLabel()
        setUpProgressBar()
        setUpVerticalStackView()
        setUpHorizontalStackView()
        view.backgroundColor = .secondarySystemBackground
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
            make.top.equalTo(titleTextView.snp.bottom).offset(Constant.screenHeight * 0.1)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constant.screenWidth / 2)
        }
    }
    
    func setUpNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(giniImageView.snp.bottom).offset(Constant.defaultPadding * 2)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpProgressBar() {
        progressContainerLabel.snp.makeConstraints { make in
            make.width.height.equalTo(
                (viewModel.progressRadius + (viewModel.progressLineWidth / 2)) * 2
            )
        }
        progressContainerLabel.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setUpVerticalStackView() {
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(infoTextView)
    }
    
    func setUpHorizontalStackView() {
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(progressContainerLabel)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(giniImageView.snp.bottom).offset(Constant.screenHeight * 0.08)
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
        titleTextView.setLineAndLetterSpacing(text: viewModel.titleText, lineSpacing: 5, font: .title1)
        infoTextView.text = viewModel.infoText
        nameLabel.text = viewModel.coredataManager.getUser().rewardName
        progressContainerLabel.text = viewModel.scoreText
        let value = CGFloat(Int(viewModel.score.description.suffix(1))!)
        progressView.progressColor = UIColor.myPointColor.cgColor
        progressView.createCircularPath()
        progressView.progressAnimation(duration: 1, value: value / 10)
    }
    
    func showAlert() {
        if viewModel.coredataManager.getUser().rewardName == "" {
            let alert = UIAlertController(title: "기니의 이름을 만들어 주세요!", message: "기니의 이름은 수정이 가능합니다.", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
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
            present(alert, animated: true)
        }
    }
}
