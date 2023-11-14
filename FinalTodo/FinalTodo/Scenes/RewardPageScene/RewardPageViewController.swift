//
//  RewardPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import SnapKit
import UIKit

final class RewardPageViewController: UIViewController {
    private var viewModel: RewardPageViewModel
    
    private lazy var rewardPageView = RewardPageView(progressView: CircularProgressView(
        round: viewModel.progressRadius,
        lineWidth: viewModel.progressLineWidth,
        circleColor: UIColor.systemGray.cgColor,
        progressColor: UIColor.myPointColor.cgColor
    ), viewModel: viewModel)
    
    // MARK: - 생성자

    init(viewModel: RewardPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        view.addSubview(rewardPageView)
        rewardPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.backgroundColor = .secondarySystemBackground
    }
}

private extension RewardPageViewController {
    // MARK: - Method
    
    func setUpImage() {
        rewardPageView.setUpImage(viewModel: viewModel)
    }
    
    func setUpText() {
        rewardPageView.setUpText(viewModel: viewModel)
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
