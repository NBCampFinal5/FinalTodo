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
    var items = [Any]()
    let locationManager = LocationTrackingManager.shared
    let viewModel = MainPageViewModel()
    
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
 
//        for i in 0...10 {
//            let folder = FolderData(id: UUID().uuidString, title: "test\(i)", color: "test\(i)")
//            viewModel.coredataManager.createFolder(newFolder: folder) {
//                print("create")
//            }
//        }

        print(viewModel.coredataManager.getFolders())
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
        switch indexPath.section {
        case 0:
            cell.configureAsAllNotesCell()
        default:
            cell.configureCellWith(item: viewModel.coredataManager.getFolders()[indexPath.row])
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
            } else if indexPath.section == 1 {
                let folder = viewModel.coredataManager.getFolders()[indexPath.row]
                print(folder)
                let vc = MemoListViewController(folder: folder)
                navigationController?.pushViewController(vc, animated: true)
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
                let targetId = viewModel.coredataManager.getFolders()[indexPath.row].id
                viewModel.coredataManager.deleteFolder(targetId: targetId) {
                    print("deleteFolderID:", targetId)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
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
    
    func configureCellWith(item: FolderData) {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        backgroundColor = ColorManager.themeArray[0].pointColor02
        textLabel?.textColor = ColorManager.themeArray[0].pointColor01
        
        textLabel?.text = item.title
        
        let size = CGSize(width: 24, height: 24)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor(hex: item.color).setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView?.image = colorImage
    }
}

extension MainPageViewController {
    func showFolderDialog(for folder: FolderData? = nil) {
        guard presentedViewController == nil else {
            print("A view controller is already presented.")
            return
        }
        
        let folderDialogVC = FolderDialogViewController()
        folderDialogVC.modalPresentationStyle = .custom
        folderDialogVC.transitioningDelegate = folderDialogVC
        folderDialogVC.initialFolder = folder
        
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

class Folder {
    var name: String
    var color: UIColor
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = Int(r*255)<<16 | Int(g*255)<<8 | Int(b*255)<<0

        return String(format: "#%06x", rgb)
    }
}
