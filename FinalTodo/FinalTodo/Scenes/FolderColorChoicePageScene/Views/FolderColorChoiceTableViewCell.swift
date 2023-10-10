//
//  FolderColorChoiceTableViewCell.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit

class FolderColorChoiceCollectionViewCell: UICollectionViewCell {

    
    static let identifier = "FolderColorChoiceCollectionViewCell"
    
    lazy var folderImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(systemName: "folder.fill")
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        return label
    }()

    private let selectedImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedImage.image = UIImage(systemName: "checkmark")
            } else {
                selectedImage.image = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(data: CellData) {
        folderImage.tintColor = data.color
        titleLabel.text = data.title
    }

}

private extension FolderColorChoiceCollectionViewCell {
    
    func setUp() {
        setUpImageView()
        setUpLabel()
        setUpSelectedImage()
        setUpDivider()
    }
    
    func setUpImageView() {
        contentView.addSubview(folderImage)
        folderImage.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenHeight * 0.025)
            make.left.equalToSuperview().offset(Constant.defaultPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(folderImage.snp.right).offset(Constant.defaultPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpSelectedImage() {
        contentView.addSubview(selectedImage)
        selectedImage.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenHeight * 0.025)
            make.right.equalToSuperview().inset(Constant.defaultPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpDivider() {
        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
}
