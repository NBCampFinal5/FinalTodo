//
//  CalendarListViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/31.
//

import UIKit

class CalendarListViewController: ModalPossibleGestureController {
    let manager = CoreDataManager.shared

    let topView = ModalTopView(title: "메모 목록")

    var date: String
    var memos: [MemoData] = []

    var onDismiss: (() -> Void)?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 90
        return tableView
    }()

    init(date: String) {
        self.date = date
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchMemoList(date: date)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetchMemoList(date: date)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        onDismiss?()
    }
}

private extension CalendarListViewController {
    func setUp() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")

        view.addSubview(topView)
        view.addSubview(tableView)

        topView.backgroundColor = .systemBackground
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func fetchMemoList(date: String) {
        // 해당 날짜 알림 설정 메모 배열
        memos = manager.getMemos().filter {
            if let notifyDate = $0.timeNotifySetting {
                if String(notifyDate).prefix(10) == date {
                    return true
                }
                return false
            }
            return false
        }
    }

    @objc func didTapBackButton() {
        self.dismiss(animated: true)
    }
}

extension CalendarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            let memoToDelete = self.memos[indexPath.row]
            CoreDataManager.shared.deleteMemo(targetId: memoToDelete.id) {
                self.memos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMemo = memos[indexPath.row]
        let editMemoVC = MemoViewController()
        editMemoVC.loadMemoData(memo: selectedMemo)
        navigationController?.pushViewController(editMemoVC, animated: true)
    }
}

extension CalendarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell

        let memo = memos[indexPath.row]
        // 메모 내용의 길이를 최대 30자로 제한
        let maxLength = 30
        let trimmedContent = String(memo.content.prefix(maxLength))
        cell.titleLabel.text = memo.content.count > maxLength ? "\(trimmedContent)..." : memo.content
        cell.dateLabel.text = memo.date
        cell.backgroundColor = .systemBackground

        return cell
    }
}
