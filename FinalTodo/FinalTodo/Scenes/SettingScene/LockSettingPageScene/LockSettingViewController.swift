//
//  LockSettingViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/22/23.
//

import UIKit
import SnapKit

class LockSettingViewController: UIViewController {
    
    private let viewModel = LockSettingViewModel()
    
    private let settingTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        return view
    }()
}

extension LockSettingViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
        bind()
    }
}

private extension LockSettingViewController {
    // MARK: - SetUp
    func setUp() {
        navigationItem.title = ""
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
    }
    
    // MARK: - Bind
    func bind() {
        viewModel.isLock.bind { [weak self] toggle in
            guard let self = self else { return }
            viewModel.userDefaultManager.setLockIsOn(toggle: toggle)
            tableViewReloadData()
        }
    }
    // MARK: - Method
    
    func tableViewReloadData() {
        UIView.transition(with: settingTableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.settingTableView.reloadData()
        })
    }

}

extension LockSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isLock.value {
            return viewModel.cellDatas.count
        } else {
            return viewModel.cellDatas.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        if viewModel.cellDatas[indexPath.row].showSwitch {
            cell.cellSwitch.isOn = viewModel.isLock.value
        }
        cell.configure(with: viewModel.cellDatas[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension LockSettingViewController: SettingCellDelegate {
    func didChangeSwitchState(_ cell: SettingCell, isOn: Bool) {
        if viewModel.userDefaultManager.getPassword().isEmpty {
            print("empty!!")
        }
        viewModel.isLock.value = isOn
    }
}
