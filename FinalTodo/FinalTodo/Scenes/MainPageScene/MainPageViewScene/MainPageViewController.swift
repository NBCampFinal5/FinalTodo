//
//  MainPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

// TODO: - View를 변경하는 이유가 뭘까요?
// TODO: - manager 위치 디자인 패턴
// TODO: - Folder클래스 삭제 및 Folders 클래스 적용

import SnapKit
import UIKit

class MainPageViewController: UIViewController {
    let locationManager = LocationTrackingManager.shared
    let viewModel = MainPageViewModel()
    let firebaseManager = FirebaseDBManager.shared
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    var mainView: MainPageView {
        return view as! MainPageView
    }
    
    override func loadView() {
        view = MainPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        setupDelegates()
        locationManager.startTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.fab.backgroundColor = .myPointColor
        navigationController?.configureBar()
        tabBarController?.configureBar()
        tabBarController?.tabBar.isHidden = false // 하위 화면에서 숨겼던 탭바 복구
        mainView.tableView.reloadData()
    }
    
    private func setupUI() {
        setupNavigationBar()
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDelegates() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.fab.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.title = "모든 폴더"
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let folderButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(folderButtonTapped))
        navigationItem.rightBarButtonItems = [folderButtonItem, searchButtonItem]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    @objc func fabTapped() {
        let addMemoVC = AddMemoPageViewController()
        addMemoVC.selectedFolderId = "allNote" // "모든 노트" 폴더에 저장하기 위한 ID 설정
        addMemoVC.transitioningDelegate = self
        addMemoVC.modalPresentationStyle = .custom
        present(addMemoVC, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        mainView.tableView.setEditing(!mainView.tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = mainView.tableView.isEditing ? "완료" : "편집"
    }
    
    @objc func searchButtonTapped() {
        let searchVC = SearchViewController()
//        searchVC.allMemos = getAllMemos()
        let navigationController = UINavigationController(rootViewController: searchVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @objc func folderButtonTapped() {
        showFolderDialog()
    }
}

extension UINavigationController {
    func configureBar() {
        navigationBar.tintColor = .myPointColor
    }
}

extension UITabBarController {
    func configureBar() {
        tabBar.tintColor = .myPointColor
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.coredataManager.getFolders().count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.configureAsAllNotesCell()
        cell.imageView?.layer.borderWidth = 0
        switch indexPath.section {
        case 0:
            cell.configureAsAllNotesCell()
        default:
            let sortedFolders = viewModel.coredataManager.getFolders()
            cell.configureCellWith(item: sortedFolders[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.isEditing {
            if indexPath.section == 1 {
                let folder = viewModel.coredataManager.getFolders()[indexPath.row]
                showFolderDialog(for: folder)
            }
        } else {
            if indexPath.section == 0 {
                let folder = FolderData(id: "allNote", title: "모든 노트", color: "")
                let vc = MemoListViewController(folder: folder)
                navigationController?.pushViewController(vc, animated: true)
                tabBarController?.tabBar.isHidden = true
            } else if indexPath.section == 1 {
                let folder = viewModel.coredataManager.getFolders()[indexPath.row]
                print(folder)
                let vc = MemoListViewController(folder: folder)
                navigationController?.pushViewController(vc, animated: true)
                tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0, 2:
//            return 10
//        default:
//            return 50
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                // 성준 - 삭제 확인을 위한 경고 알럿
                let alert = UIAlertController(title: "주의", message: "삭제 시 메모도 함께 삭제됩니다.\n삭제하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                    guard let self = self else { return }
                    // 폴더 삭제 로직
                    let targetId = self.viewModel.coredataManager.getFolders()[indexPath.row].id
                    self.viewModel.coredataManager.deleteFolder(targetId: targetId) {
                        print("deleteFolderID:", targetId)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

                present(alert, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // TODO: - 추후 구현 요망
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: - 추후 구현 요망
    }
}

extension UITableViewCell {
    func configureAsSpacingCell() {
        textLabel?.text = nil
        layer.borderWidth = 0
        selectionStyle = .none
        imageView?.image = .none
    }
    
    func configureAsAllNotesCell() {
//        contentView.backgroundColor = .secondarySystemBackground
        textLabel?.text = "모든 노트"
        let templateImage = UIImage(systemName: "note.text")?.withRenderingMode(.alwaysTemplate)
        imageView?.image = templateImage
        imageView?.tintColor = .myPointColor
    }
    
    func configureCellWith(item: FolderData) {
        textLabel?.textColor = .label
//        contentView.backgroundColor = .secondarySystemBackground
        
        textLabel?.text = item.title
        
        let length: CGFloat = 24
        let size = CGSize(width: length, height: length)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor(hex: item.color).setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
//        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView?.layer.borderWidth = 0.2
        imageView?.layer.borderColor = UIColor.label.cgColor
        imageView?.layer.cornerRadius = length / 2
        imageView?.image = colorImage
    }
}

extension MainPageViewController {
    func showFolderDialog(for folder: FolderData? = nil) {
        guard presentedViewController == nil else {
            print("A view controller is already presented.")
            return
        }
        backView.alpha = 0.4
        let folderDialogVC = FolderDialogViewController()
        folderDialogVC.modalPresentationStyle = .custom
        folderDialogVC.transitioningDelegate = folderDialogVC
        folderDialogVC.initialFolder = folder
        
        folderDialogVC.dismiisComplettion = { [weak self] in
            self?.backView.alpha = 0
        }
        
        folderDialogVC.completion = { [weak self] title, color, id in
            if let id = id {
                let folder = FolderData(id: id, title: title, color: color.toHexString())
                self?.viewModel.coredataManager.updateFolder(targetId: id, newFolder: folder, completion: {
                    print("folderUpdate")
                })
            } else {
                let folder = FolderData(id: UUID().uuidString, title: title, color: color.toHexString())
                self?.viewModel.coredataManager.createFolder(newFolder: folder, completion: {
                    print("folderCreate")
                })
            }
            self?.mainView.tableView.reloadData()
        }
        
        present(folderDialogVC, animated: true, completion: nil)
    }
    
    func changeStatusBarBgColor(bgColor: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
            
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = bgColor
            
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
}

extension MainPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
    }
}
