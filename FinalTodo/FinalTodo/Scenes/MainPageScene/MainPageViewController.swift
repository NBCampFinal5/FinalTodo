//
//  MainPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit

class MainPageViewController: UIViewController {
    
    var items = [Any]()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.isTranslucent = false
        
        setupFAB()
        setupTableView()
        setupNavigationBar()
    }
    
    let fab: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private func setupFAB() {
        view.addSubview(fab)
        
        fab.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        fab.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom) // 이 부분을 변경했습니다.
            make.left.right.equalTo(view)
        }
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.bringSubviewToFront(fab)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        
        title = "리스트"
        
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let folderButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(folderButtonTapped))
        navigationItem.rightBarButtonItems = [folderButtonItem, searchButtonItem]
    }
    
    @objc func fabTapped() {
    }
    
    @objc func editButtonTapped() {
    }
    
    @objc func searchButtonTapped() {
    }
    
    @objc func folderButtonTapped() {
        showFolderDialog()
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .white
        
        if indexPath.row == 0 || indexPath.row == 2 {
            cell.textLabel?.text = nil
            cell.layer.borderWidth = 0
            cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cell.selectionStyle = .none
            cell.imageView?.image = .none
            return cell
        }
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        
        if indexPath.row == 1 {
            cell.textLabel?.text = "모든 노트"
            cell.imageView?.image = UIImage(systemName: "note.text")
        } else {
            if let item = items[indexPath.row - 3] as? String {
                cell.textLabel?.text = item
            } else if let folder = items[indexPath.row - 3] as? Folder {
                cell.textLabel?.text = folder.name
            }
        }
        
        if indexPath.row >= 3 && indexPath.row - 3 < items.count {
            if let item = items[indexPath.row - 3] as? String {
                cell.textLabel?.text = item
            } else if let folder = items[indexPath.row - 3] as? Folder {
                cell.textLabel?.text = folder.name
                
                let size = CGSize(width: 24, height: 24)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                folder.color.setFill()
                UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
                let colorImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                cell.imageView?.image = colorImage
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 {
            return 10
        } else if indexPath.row == 1 {
            return 50
        } else {
            return 50
        }
    }
}

extension MainPageViewController {
    func showFolderDialog() {
        if self.presentedViewController == nil {
            let folderDialogVC = FolderDialogViewController()
            folderDialogVC.modalPresentationStyle = .custom
            folderDialogVC.transitioningDelegate = folderDialogVC
            
            folderDialogVC.completion = { [weak self] (name, color) in
                self?.items.append(Folder(name: name, color: color))
                self?.tableView.reloadData()
            }
            
            present(folderDialogVC, animated: true, completion: nil)
        } else {
            print("A view controller is already presented.")
        }
    }
}

struct Folder {
    var name: String
    var color: UIColor
}
