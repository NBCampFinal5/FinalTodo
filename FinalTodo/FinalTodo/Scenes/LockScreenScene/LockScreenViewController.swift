//
//  LockScreenViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/18/23.
//

import UIKit
import SnapKit

class LockScreenViewController: UIViewController {
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "암호 입력"
        return label
    }()
    
    lazy var passwordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: viewModel.passwordCollectionviewItemSize.width, height: viewModel.passwordCollectionviewItemSize.height)
        flowLayout.minimumLineSpacing = viewModel.passwordCollectionviewSpacing
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var numsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing = viewModel.numPadCollectionviewSpacing
        flowLayout.minimumLineSpacing = spacing / 2
        flowLayout.itemSize = .init(width: viewModel.numPadCollectionviewItemSize.width, height: viewModel.numPadCollectionviewItemSize.height)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    private let viewModel: LockScreenViewModel
    
    init(rootViewController: UIViewController, targetViewController: UIViewController) {
        self.viewModel = LockScreenViewModel(rootViewController: rootViewController, targetViewController: targetViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[LockScreenViewController]: deinit")
    }
}

extension LockScreenViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}

private extension LockScreenViewController {
    
    // MARK: - Bind
    
    func bind() {
        viewModel.userInPutPassword.bind { [weak self] inputData in
            guard let self = self else { return }
            passwordCollectionView.reloadData()
            if inputData.count == viewModel.lockScreenPassword.count {
                if inputData == viewModel.lockScreenPassword {
                    print("[LockScreenViewController]: 비밀번호 일치")
                    self.navigationController?.popViewController(animated: false, completion: {
                        let vc = self.viewModel.targetViewController
                        self.viewModel.rootViewController.navigationController?.pushViewController(vc, animated: true)
                    })
                } else {
                    print("[LockScreenViewController]: 비밀번호 불일치")
                }
            }
        }
    }

    
    // MARK: - SetUp

    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        view.addSubview(numsCollectionView)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        setUpPasswordLabel()
        setUpPasswordCollectionView()
        setUpNumsCollectionView()
    }
    
    func setUpPasswordLabel() {
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.15)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpPasswordCollectionView() {
        view.addSubview(passwordCollectionView)
        passwordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.equalToSuperview()
            make.height.equalTo(viewModel.passwordCollectionviewItemSize.height)
        }
        passwordCollectionView.delegate = self
        passwordCollectionView.dataSource = self
        passwordCollectionView.register(LockScreenPasswordCollectionViewCell.self, forCellWithReuseIdentifier: LockScreenPasswordCollectionViewCell.identifier)
    }
    
    func setUpNumsCollectionView() {
        numsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(passwordCollectionView.snp.bottom).offset(Constant.screenHeight * 0.1)
            make.left.right.equalToSuperview().inset(Constant.defaultPadding * 3)
            make.bottom.equalToSuperview()
        }
        numsCollectionView.delegate = self
        numsCollectionView.dataSource = self
        numsCollectionView.register(LockScreenNumCollectionViewCell.self, forCellWithReuseIdentifier: LockScreenNumCollectionViewCell.identifier)
    }
}

extension LockScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == passwordCollectionView {
            return viewModel.lockScreenPassword.count
        } else {
            return viewModel.numPadComposition.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == passwordCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenPasswordCollectionViewCell.identifier, for: indexPath) as! LockScreenPasswordCollectionViewCell
            if indexPath.row < viewModel.userInPutPassword.value.count {
                cell.bind(toggle: true)
            } else {
                cell.bind(toggle: false)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LockScreenNumCollectionViewCell.identifier, for: indexPath) as! LockScreenNumCollectionViewCell
            cell.bind(title: viewModel.numPadComposition[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.numPadComposition[indexPath.row] {
        case "AC":
            viewModel.userInPutPassword.value = ""
        case "C":
            if viewModel.userInPutPassword.value.count != 0 {
                let _ = viewModel.userInPutPassword.value.popLast()
            }
        default:
            if viewModel.lockScreenPassword.count > viewModel.userInPutPassword.value.count {
                viewModel.userInPutPassword.value += viewModel.numPadComposition[indexPath.row]
            }
        }
    }
    
    
}

extension LockScreenViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == passwordCollectionView {
            let count = Double(viewModel.lockScreenPassword.count)
            let totalCellWidth = viewModel.passwordCollectionviewItemSize.width * count
            let totalSpacingWidth = viewModel.passwordCollectionviewSpacing * (count - 1)
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension UINavigationController {
    func popViewController(animated: Bool, completion:@escaping (()->())) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        _ = self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion:@escaping (()->())) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
