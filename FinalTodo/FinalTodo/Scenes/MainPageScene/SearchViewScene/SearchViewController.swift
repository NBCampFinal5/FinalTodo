//
//  SearchViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/25.
//

// SearchViewController.swift

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        bind()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupTableView()
        setupSearchBar()
    }
    
    private func bind() {
        viewModel.filterData.bind { [weak self] memos in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MemoCell.self, forCellReuseIdentifier: "memoCell")
        tableView.rowHeight = 80
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "메모 검색"
        navigationItem.titleView = searchBar
    }
    
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = closeButton
    }
    
//    private func filterMemos(with searchText: String) {
//        if searchText.isEmpty {
////            filteredMemos = allMemos
//            viewModel.filterData
//        } else {
////            filteredMemos = allMemos.filter { $0.title.range(of: searchText, options: .caseInsensitive) != nil }
//        }
//    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filterData.value = viewModel.coredataManager.getMemos()
        } else {
            viewModel.filterData.value = viewModel.coredataManager.getMemos().filter{$0.content.contains(searchText)}
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as! MemoCell
        let memo = viewModel.filterData.value[indexPath.row]
        cell.configure(with: memo, dateFormatter: dateFormatter)
        return cell
    }
}

extension MemoCell {
    func configure(with memo: MemoData, dateFormatter: DateFormatter) {
        titleLabel.text = memo.content
        dateLabel.text = memo.date
        folderNameLabel.text = memo.folderId
//        folderColorView.backgroundColor = memo.co
    }
}






