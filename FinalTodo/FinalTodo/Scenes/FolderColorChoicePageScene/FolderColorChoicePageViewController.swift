//
//  FolderColorChoicepageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit

struct CellData {
    let title: String
    let color: UIColor
}

final class FolderColorChoicePageViewController: UIViewController {


    private let folderColorCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: Constant.screenWidth, height: Constant.screenHeight * 0.05)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return view
    }()
    
    let dummyData: [CellData] = [
        CellData(title: "빨강", color: .red),
        CellData(title: "주황", color: .orange),
        CellData(title: "노랑", color: .systemYellow),
        CellData(title: "초록", color: .green),
        CellData(title: "파랑", color: .blue)
    ]
}

extension FolderColorChoicePageViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension FolderColorChoicePageViewController {
    // MARK: - setUp

    func setUp(){
        folderCollectionViewViewSetUp()
    }
    
    func folderCollectionViewViewSetUp() {
        view.addSubview(folderColorCollectionView)
        folderColorCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        folderColorCollectionView.delegate = self
        folderColorCollectionView.dataSource = self
        folderColorCollectionView.register(FolderColorChoiceCollectionViewCell.self, forCellWithReuseIdentifier: FolderColorChoiceCollectionViewCell.identifier)
        folderColorCollectionView.allowsMultipleSelection = false
    }
}


extension FolderColorChoicePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderColorChoiceCollectionViewCell.identifier, for: indexPath) as! FolderColorChoiceCollectionViewCell
        cell.bind(data: dummyData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
}
