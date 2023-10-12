//
//  FolderDialogViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/11.
//

import UIKit
import SnapKit

class FolderDialogViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    var titleLabel: UILabel!
    var folderNameTextField: UITextField!
    var colorIconView: UIView!
    var colorTitleLabel: UILabel!
    var colorNameLabel: UILabel!
    var arrowImageView: UIImageView!
    var initialFolder: Folder?
    
    var selectedColor: UIColor = .white {
        didSet {
            colorIconView.backgroundColor = selectedColor
        }
    }
    
    var completion: ((String, UIColor) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setFolder()
    }
    
    func setFolder() {
        if let initialFolder = initialFolder {
            folderNameTextField.text = initialFolder.name
            selectedColor = initialFolder.color
        }
    }
    
    func setupUI() {
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        titleLabel = UILabel()
        titleLabel.text = "폴더 명"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        folderNameTextField = UITextField()
        folderNameTextField.placeholder = "폴더 이름 입력"
        folderNameTextField.borderStyle = .roundedRect
        view.addSubview(folderNameTextField)
        folderNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        colorIconView = UIView()
        colorIconView.layer.cornerRadius = 5
        colorIconView.layer.borderWidth = 0.5
        colorIconView.layer.borderColor = UIColor.black.cgColor
        colorIconView.backgroundColor = selectedColor
        
        colorIconView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        colorTitleLabel = UILabel()
        colorTitleLabel.text = "컬러"
        
        arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        
        let colorStackView = UIStackView(arrangedSubviews: [colorIconView, colorTitleLabel, arrowImageView])
        colorStackView.axis = .horizontal
        colorStackView.spacing = 10
        colorStackView.alignment = .center
        colorStackView.distribution = .fill
        view.addSubview(colorStackView)
        
        colorStackView.snp.makeConstraints { make in
            make.top.equalTo(folderNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectColor))
        colorStackView.addGestureRecognizer(colorTapGesture)
        colorStackView.isUserInteractionEnabled = true
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelDialog), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("작성", for: .normal)
        addButton.addTarget(self, action: #selector(addFolder), for: .touchUpInside)
        view.addSubview(addButton)
        
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, addButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(colorStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    @objc func selectColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.selectedColor = selectedColor
        present(colorPickerVC, animated: true, completion: nil)
    }
    
    
    @objc func addFolder() {
        if let name = folderNameTextField.text, !name.isEmpty {
            completion?(name, selectedColor)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancelDialog() {
        dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        DispatchQueue.main.async {
            self.selectedColor = viewController.selectedColor
        }
    }
    
}

extension FolderDialogViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class CustomSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let size = CGSize(width: containerView.bounds.width * 0.75, height: containerView.bounds.height * 0.3)
        let origin = CGPoint(x: (containerView.bounds.width - size.width) / 2, y: (containerView.bounds.height - size.height) / 2)
        
        return CGRect(origin: origin, size: size)
    }
}



