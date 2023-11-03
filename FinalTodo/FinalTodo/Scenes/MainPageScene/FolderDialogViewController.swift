//
//  FolderDialogViewController.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/11.
//

import UIKit
import SnapKit

// TODO: - manager 위치 디자인 패턴
// TODO: - 공용 폰트 적용
// TODO: - Offset inset Constant.defaultPadding값으로 통일하기

class FolderDialogViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    var titleLabel: UILabel!
    var folderNameTextField: UITextField!
    var colorIconView: UIView!
    var colorTitleLabel: UILabel!
    var colorNameLabel: UILabel!
    var arrowImageView: UIImageView!
    var initialFolder: FolderData?
    
    var selectedColor: UIColor = .white {
        didSet {
            colorIconView.backgroundColor = selectedColor
        }
    }
    
    var completion: ((String, UIColor, String?) -> Void)?
    var dismiisComplettion: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setFolder()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        dismiisComplettion()
    }
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.5
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height/2.5)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    func setFolder() {
        if let initialFolder = initialFolder {
            folderNameTextField.text = initialFolder.title
            selectedColor = UIColor(hex: initialFolder.color)
        }
    }
    
    func setupUI() {
        
        view.backgroundColor = .systemBackground
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
            completion?(name, selectedColor, initialFolder?.id)
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



