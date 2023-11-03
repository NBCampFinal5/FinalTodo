//
//  RewardPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

class RewardPageViewController: UIViewController {

    private let viewModel = RewardPageViewController()
    let titleTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = false
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .headline)
        view.text = "어쩌구저쩌구님은\nn개의 메모를 작성했어요."
        return view
    }()
    
    let giniImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gini1")
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "김춘식"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.backgroundColor = .blue
        return view
    }()

    let progressView: CircularProgressView = {
        let size = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = CircularProgressView(round: 100, lineWidth: 10)
//        view.progressAnimation(duration: 1, value: 0.2)
        view.backgroundColor = .blue
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "DDddd"
        return label
    }()
}

extension RewardPageViewController {
    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
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
        setUpNameLabel()
        setUpStackView()
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
            make.top.equalTo(titleTextView.snp.bottom).offset(Constant.defaultPadding * 2)
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
    
    func setUpStackView() {
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.centerX.equalToSuperview()

        }
    }
}

extension RewardPageViewController {
    // MARK: - Method
    
    

}

class CircularProgressView: UIView {
    // First create two layer properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var round: CGFloat
    private var lineWidth: CGFloat
    
    init (round: CGFloat, lineWidth: CGFloat){
        self.round = round
        self.lineWidth = lineWidth
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
        circleLayer.strokeColor = UIColor.black.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth / 2
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.red.cgColor
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
