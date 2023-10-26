//
//  MainPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit

// TODO: - View를 변경하는 이유가 뭘까요?
// TODO: - manager 위치 디자인 패턴
// TODO: - Folder클래스 삭제 및 Folders 클래스 적용

class MainPageViewController: UIViewController {
    
    var items = [Any]()
    let locationManager = LocationTrackingManager.shared
    let coredataManager = CoreDataManager.shared
    
    var mainView: MainPageView {
        return view as! MainPageView
    }
    
    override func loadView() {
        view = MainPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        locationManager.startTracking()
    }
    
    private func setupUI() {
        setupNavigationBar()
        navigationController?.configureBar()
        tabBarController?.configureBar()
        changeStatusBarBgColor(bgColor: ColorManager.themeArray[0].backgroundColor!)
    }
    
    private func setupDelegates() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.fab.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        title = "리스트"
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let folderButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(folderButtonTapped))
        navigationItem.rightBarButtonItems = [folderButtonItem, searchButtonItem]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ColorManager.themeArray[0].pointColor01 ?? .black]
    }
    
    @objc func fabTapped() {
        let addMemoVC = AddMemoPageViewController()
        addMemoVC.transitioningDelegate = self
        addMemoVC.modalPresentationStyle = .custom
        self.present(addMemoVC, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped() {
        mainView.tableView.setEditing(!mainView.tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = mainView.tableView.isEditing ? "완료" : "편집"
    }
    
    @objc func searchButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.allMemos = getAllMemos()
        let navigationController = UINavigationController(rootViewController: searchVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func getAllMemos() -> [Memo] {
        return items.compactMap { $0 as? Memo }
    }

    @objc func folderButtonTapped() {
        showFolderDialog()
    }
    
}

extension UINavigationController {
    func configureBar() {
        navigationBar.tintColor = ColorManager.themeArray[0].pointColor01
        navigationBar.backgroundColor = ColorManager.themeArray[0].backgroundColor
    }
}

extension UITabBarController {
    func configureBar() {
        tabBar.tintColor = ColorManager.themeArray[0].pointColor01
        tabBar.backgroundColor = ColorManager.themeArray[0].backgroundColor
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.configureAsSpacingCell()
        
        switch indexPath.row {
        case 0, 2:
            break
        case 1:
            cell.configureAsAllNotesCell()
        default:
            cell.configureCellWith(item: items[indexPath.row - 3])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row > 2 else { return }
        
        let selectedItem = items[indexPath.row - 3]
        if tableView.isEditing {
            if let folder = selectedItem as? Folder {
                showFolderDialog(for: folder)
            }
        } else {
            if let selectedFolder = selectedItem as? Folder {
                let memoListViewVC = MemoListViewController(folder: selectedFolder)
                navigationController?.pushViewController(memoListViewVC, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2:
            return 10
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, indexPath.row > 2 else { return }
        
        items.remove(at: indexPath.row - 3)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 2
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = items[sourceIndexPath.row - 3]
        items.remove(at: sourceIndexPath.row - 3)
        items.insert(movedObject, at: destinationIndexPath.row - 3)
    }
    
}

extension UITableViewCell {
    func configureAsSpacingCell() {
        textLabel?.text = nil
        layer.borderWidth = 0
        backgroundColor = ColorManager.themeArray[0].backgroundColor
        selectionStyle = .none
        imageView?.image = .none
    }
    
    func configureAsAllNotesCell() {
        textLabel?.text = "모든 노트"
        textLabel?.textColor = ColorManager.themeArray[0].pointColor01
        let templateImage = UIImage(systemName: "note.text")?.withRenderingMode(.alwaysTemplate)
        imageView?.image = templateImage
        imageView?.tintColor = ColorManager.themeArray[0].pointColor01
        layer.borderColor = ColorManager.themeArray[0].pointColor01?.cgColor
        layer.borderWidth = 0.5
        backgroundColor = ColorManager.themeArray[0].pointColor02
    }
    
    func configureCellWith(item: Any) {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        backgroundColor = ColorManager.themeArray[0].pointColor02
        textLabel?.textColor = ColorManager.themeArray[0].pointColor01
        
        if let itemString = item as? String {
            textLabel?.text = itemString
        } else if let folder = item as? Folder {
            textLabel?.text = folder.name
            let size = CGSize(width: 24, height: 24)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            folder.color.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageView?.image = colorImage
        }
    }
}

extension MainPageViewController {
    func showFolderDialog(for folder: Folder? = nil) {
        guard self.presentedViewController == nil else {
            print("A view controller is already presented.")
            return
        }
        
        let folderDialogVC = FolderDialogViewController()
        folderDialogVC.modalPresentationStyle = .custom
        folderDialogVC.transitioningDelegate = folderDialogVC
        folderDialogVC.initialFolder = folder
        
        folderDialogVC.completion = { [weak self] (name, color) in
            if let existingFolderIndex = self?.index(for: folder) {
                self?.updateFolder(at: existingFolderIndex, with: name, color: color)
            } else {
                self?.addNewFolder(with: name, color: color)
            }
            self?.mainView.tableView.reloadData()
        }
        
        present(folderDialogVC, animated: true, completion: nil)
    }
    
    private func index(for folder: Folder?) -> Int? {
        return items.firstIndex(where: { ($0 as? Folder)?.name == folder?.name })
    }
    
    private func updateFolder(at index: Int, with name: String, color: UIColor) {
        guard let folder = items[index] as? Folder else { return }
        folder.name = name
        folder.color = color
    }
    
    private func addNewFolder(with name: String, color: UIColor) {
        items.append(Folder(name: name, color: color))
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


class Folder {
    var name: String
    var color: UIColor
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}

