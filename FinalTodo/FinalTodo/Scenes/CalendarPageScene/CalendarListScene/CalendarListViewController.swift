//
//  CalendarListViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/31.
//

import UIKit

class CalendarListViewController: UIViewController {
    let manager = CoreDataManager.shared

    let topView = ModalTopView(title: "")

    var date: String
    var memos: [MemoData] = []

    var onDismiss: (() -> Void)?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = Constant.screenWidth / 6.5
        return tableView
    }()

    init(date: String) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
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
        tableView.separatorStyle = .none
        tableView.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")

        view.addSubview(topView)
        view.addSubview(tableView)

        topView.backgroundColor = .systemBackground
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constant.screenHeight * 0.07)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func fetchMemoList(date: String) {
        memos = manager.getMemos().filter { $0.date.prefix(10) == date } // 날짜에 해당하는 메모 불러와서 앞에 10글자 비교
        print("@@ 선택 일자 메모: \(memos), 선택 일자: \(date)")
        print("@@", manager.getMemos().first!.date)
    }

    @objc func didTapBackButton() {
        navigationController?.dismiss(animated: true, completion: onDismiss)
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
        cell.titleLabel.text = memo.content
        cell.dateLabel.text = memo.date
        cell.backgroundColor = .clear

        return cell
    }
}
