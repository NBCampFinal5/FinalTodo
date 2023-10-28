//
//  ColorUiViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/26/23.
//

import UIKit
import SnapKit

class ColorUIViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    lazy var theme1View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: coredataManager.getUser().themeColor)
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let theme2View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "theme01PointColor03")
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let themeColorLabel: UILabel = {
        let label = UILabel()
        label.text = "테마 컬러"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let firstColorLabel: UILabel = {
        let label = UILabel()
        label.text = "컬러 1"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let secondColorLabel: UILabel = {
        let label = UILabel()
        label.text = "컬러 2"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    
    private let firstColorChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("첫번째 컬러", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showFirstColorPicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let secondColorChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("두번째 컬러", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showSecondColorPicker), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let coredataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "theme01PointColor03")

        setUp()
        setupColorPicker()
    
    }
}
    private extension ColorUIViewController {
        // MARK: - SetUp
        func setUp() {
            setUptheme1()
//            setUptheme2()
         
        }
        
        func setUptheme1() {

            view.addSubview(themeColorLabel)
            themeColorLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(Constant.screenHeight * 0.03)
                make.leading.equalTo(Constant.defaultPadding)
            }
            
            view.addSubview(firstColorLabel)
            firstColorLabel.snp.makeConstraints { make in
                make.top.equalTo(themeColorLabel.snp.bottom).offset(Constant.screenHeight * 0.07)
                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
            }
            
            view.addSubview(theme1View)
            theme1View.snp.makeConstraints { make in
                make.top.equalTo(firstColorLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
                make.centerX.equalToSuperview()
               
                make.height.equalTo(Constant.screenHeight * 0.1)
                make.width.equalTo(Constant.screenHeight * 0.1)
            }
            
            view.addSubview(firstColorChangeButton)
            firstColorChangeButton.snp.makeConstraints { make in
                make.top.equalTo(theme1View.snp.bottom).offset(Constant.screenHeight * 0.01)
                make.centerX.equalToSuperview()
            }
        }
        
        
//        func setUptheme2() {
//            
//            view.addSubview(secondColorLabel)
//            secondColorLabel.snp.makeConstraints { make in
//                make.top.equalTo(theme1View.snp.bottom).offset(Constant.screenHeight * 0.1)
//                make.leading.trailing.equalToSuperview().inset(Constant.defaultPadding)
//            }
//            view.addSubview(theme2View)
//            theme2View.snp.makeConstraints { make in
//                make.top.equalTo(secondColorLabel.snp.bottom).offset(Constant.screenHeight * 0.05)
//                make.centerX.equalToSuperview()
//                make.height.equalTo(Constant.screenHeight * 0.1)
//                make.width.equalTo(Constant.screenHeight * 0.1)
//            }
//            
//            view.addSubview(secondColorChangeButton)
//            secondColorChangeButton.snp.makeConstraints { make in
//                make.top.equalTo(theme2View.snp.bottom).offset(Constant.screenHeight * 0.01)
//                make.centerX.equalToSuperview()
//            }
//        }
    
    }


extension ColorUIViewController {
    // 컬러 피커를 설정하는 함수
    private func setupColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.supportsAlpha = true
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceView = firstColorChangeButton
        colorPicker.popoverPresentationController?.sourceView = secondColorChangeButton
        // 뷰 컨트롤러에 컬러 피커를 추가합니다.
        self.addChild(colorPicker)
    }

    @objc private func showFirstColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = theme1View.backgroundColor ?? .white
        picker.supportsAlpha = true
        // 첫 번째 컬러 피커를 표시할 때는 첫 번째 버튼의 태그를 설정
        firstColorChangeButton.tag = 1
        secondColorChangeButton.tag = 0 // 두 번째 버튼의 태그를 초기화
        self.present(picker, animated: true, completion: nil)
    }

    @objc private func showSecondColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = theme2View.backgroundColor ?? .white
        picker.supportsAlpha = true
        // 두 번째 컬러 피커를 표시할 때는 두 번째 버튼의 태그를 설정
        firstColorChangeButton.tag = 0 // 첫 번째 버튼의 태그를 초기화
        secondColorChangeButton.tag = 2
        self.present(picker, animated: true, completion: nil)
    }


    // 사용자가 색상을 선택하면 호출되는 델리게이트 메서드
    func showColorPicker(_ sender: Any) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = UIColor.cyan
            picker.supportsAlpha = true
            self.present(picker, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {

        // 버튼의 태그를 사용하여 어떤 버튼을 클릭했는지 구별
//        if firstColorChangeButton.tag == 1 {
//            theme1View.backgroundColor = viewController.selectedColor
//        } else if secondColorChangeButton.tag == 2 {
//            theme2View.backgroundColor = viewController.selectedColor
//        }

        
        let user = coredataManager.getUser()
        
        if user.id == "error" {
            let alert = UIAlertController(title: "오류", message: "로그인이 필요합니다", preferredStyle: .alert)
            let yes = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(yes)
            present(alert, animated: true)
        } else {
            let color = viewController.selectedColor.toHexString()
            let updateUser = UserData(id: user.id, nickName: user.nickName, folders: user.folders, memos: user.memos, rewardPoint: user.rewardPoint, rewardName: user.rewardName, themeColor: color)
            coredataManager.updateUser(targetId: user.id, newUser: updateUser) {
                print("Update Color")
            }
            UIColor.myPointColor = UIColor(hex: color)
            theme1View.backgroundColor = UIColor(hex: color)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }



}


