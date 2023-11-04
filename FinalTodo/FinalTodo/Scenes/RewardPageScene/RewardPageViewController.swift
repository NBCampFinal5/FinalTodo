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
        view.text = "어쩌구저쩌구님은\n지금까지 123개의\n메모를 작성했어요."
        return view
    }()
    
    private let giniImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gini1")
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "김춘식김춘식김"
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
        label.text = "n개의 메모를 작성하면 다음 기니를 만날 수 있어요"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        return label
    }()
}

extension RewardPageViewController {
    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        viewModel = RewardPageViewModel()
        setUpText()
        setUpImage()
    }
    
    override func viewDidLoad() {
        setUpNavigation()
        setUp()
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
        let value = CGFloat(Int(viewModel.score.description.suffix(1))!)
        progressView.progressAnimation(duration: 0.4, value: value / 10)
    }

}

class CircularProgressView: UIView {
    // First create two layer properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var round: CGFloat
    private var lineWidth: CGFloat
    private var circleColor: CGColor
    private var progressColor: CGColor
    
    init (round: CGFloat, lineWidth: CGFloat, circleColor: CGColor, progressColor: CGColor){
        self.round = round
        self.lineWidth = lineWidth
        self.circleColor = circleColor
        self.progressColor = progressColor
        super.init(frame: .zero)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: round, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = circleColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth / 2
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(duration: TimeInterval, value: CGFloat) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
