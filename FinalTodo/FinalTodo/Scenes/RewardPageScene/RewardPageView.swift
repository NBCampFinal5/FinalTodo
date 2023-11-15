//
//  RewardPageView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 11/14/23.
//

import UIKit

final class RewardPageView: UIView {

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
    
    private var progressView: CircularProgressView
    
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
    
    // MARK: - 생성자
    init(progressView: CircularProgressView, viewModel: RewardPageViewModel) {
        self.progressView = progressView
        super.init(frame: .zero)
        setUp(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RewardPageView {
    // MARK: - SetUp
    
    func setUp(viewModel: RewardPageViewModel) {
        titleTextView.text = viewModel.titleText
        setUpTitleTextView()
        setUpGiniImageView()
        setUpNameLabel()
        setUpProgressBar(viewModel: viewModel)
        setUpVerticalStackView()
        setUpHorizontalStackView()
        
    }
    
    func setUpTitleTextView() {
        self.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.defaultPadding)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding)
            make.height.equalTo(Constant.screenHeight * 0.25)
        }
    }
    
    func setUpGiniImageView() {
        self.addSubview(giniImageView)
        giniImageView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Constant.screenHeight * 0.1)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constant.screenWidth / 2)
        }
    }
    
    func setUpNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(giniImageView.snp.bottom).offset(Constant.defaultPadding * 2)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpProgressBar(viewModel: RewardPageViewModel) {
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
        self.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(progressContainerLabel)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(giniImageView.snp.bottom).offset(Constant.screenHeight * 0.08)
            make.centerX.equalToSuperview()
        }
    }
}

extension RewardPageView {
    func setUpImage(viewModel: RewardPageViewModel) {
        var scoreString = viewModel.score.description
        scoreString.removeLast()
        guard let value = Int(scoreString) else { return }
        giniImageView.image = UIImage(named: "gini\(value + 1)")
    }
    
    func setUpText(viewModel: RewardPageViewModel) {
        titleTextView.setLineAndLetterSpacing(text: viewModel.titleText, lineSpacing: 5, font: .title1)
        infoTextView.text = viewModel.infoText
        nameLabel.text = viewModel.coredataManager.getUser().rewardName
        progressContainerLabel.text = viewModel.scoreText
        let value = CGFloat(Int(viewModel.score.description.suffix(1))!)
        progressView.progressColor = UIColor.myPointColor.cgColor
        progressView.createCircularPath()
        progressView.progressAnimation(duration: 1, value: value / 10)
    }
}
