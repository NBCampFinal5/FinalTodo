//
//  RewardPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit

class RewardPageViewController: UIViewController {
    
    
    private var score = 0
    //버튼들
    lazy var plusButton:UIButton = {
        let button = UIButton()
        button.setTitle("+1", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
        button.addTarget(self, action: #selector(increaseScore), for: .touchUpInside)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        return button
    }()
    lazy var minusButton:UIButton = {
        let button = UIButton()
        button.setTitle("-1", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
        button.addTarget(self, action: #selector(diminishScore), for: .touchUpInside)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var manualButton:UIButton = {
        let button = UIButton()
        let image = UIImage(named: "question")
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
        return button
    }()
    
    //이미지뷰
    let giniimageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "gini1")
        return ImageView
    }()
    
    let rewardView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "reward2")
        return ImageView
    }()
    
    //레이블
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    lazy var giniName: UILabel = {
        let label = UILabel()
        label.text = "기니피그"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "theme01PointColor02")
        scoreLabel.text = "\(score)"
        setup()
    }
}

private extension RewardPageViewController{
    func setup() {
        setupImageView()
        setupButton()
        setuplabel()
    }
    
    func setupImageView(){
        
        view.addSubview(giniimageView)
        giniimageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        
    }
    func setupButton(){
        
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(giniimageView.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalToSuperview().offset(Constant.screenWidth * 0.3)
            make.width.equalTo(view.snp.width).multipliedBy(0.1)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        view.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalToSuperview().offset(Constant.screenWidth * 0.3)
            make.width.equalTo(view.snp.width).multipliedBy(0.1)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        view.addSubview(manualButton)
        manualButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constant.screenHeight * 0.15) // 아래에서부터 떨어진 위치 조정
            make.leading.equalToSuperview().offset(Constant.screenWidth * 0.1) // 왼쪽에서부터 떨어진 위치 조정
            make.width.equalTo(view.snp.width).multipliedBy(0.1)
            make.height.equalTo(view.snp.height).multipliedBy(0.07)
        }
    }
    func setuplabel(){
        
        view.addSubview(giniName)
        giniName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.1) // 상단에 간격 추가
            make.centerX.equalToSuperview()
        }
        view.addSubview(rewardView)
        rewardView.snp.makeConstraints { make in
            make.top.equalTo(giniName.snp.bottom).offset(Constant.screenHeight * 0.01) // 아래에서부터 떨어진 위치 조정
            make.leading.equalToSuperview().offset(Constant.screenWidth * 0.01) // 왼쪽에서부터의 위치 조정
            make.width.equalTo(view.snp.width).multipliedBy(0.1)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(giniName.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.leading.equalTo(rewardView.snp.trailing)
            make.width.equalTo(view.snp.width).multipliedBy(0.1)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
    }
}

extension RewardPageViewController {
    
    @objc func increaseScore() {
        score += 1
            scoreLabel.text = "\(score)"
            
            switch score {
            case 10:
                giniimageView.image = UIImage(named: "gini2")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // 이미지 확대
                })
            case 20:
                giniimageView.image = UIImage(named: "gini3")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.4)
                })
            case 30:
                giniimageView.image = UIImage(named: "gini4")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.21, y: 1.41)
                })
            default:
                break // 다른 점수에 대한 특별한 조치 없음
            }
    }
    @objc func diminishScore() {
        // 버튼을 누를 때 호출되는 함수
        if score > 0 {
            score -= 1
            scoreLabel.text = "\(score)"
            
            switch score {
            case 9:
                giniimageView.image = UIImage(named: "gini1")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // 이미지 확대
                })
            case 10:
                giniimageView.image = UIImage(named: "gini2")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // 이미지 확대
                })
            case 20:
                giniimageView.image = UIImage(named: "gini3")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.4)
                })
            case 30:
                giniimageView.image = UIImage(named: "gini4")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = CGAffineTransform(scaleX: 1.21, y: 1.41)
                })
            default:
                break // 다른 점수에 대한 특별한 조치 없음
            }
        }
    }
    
    
    @objc func showPopup() {
        let alertController = UIAlertController(title: "포인트로 기니피그를 키워보세요.", message: "매일 출석, 또는 할일을 끝내고\n포인트를 쌓아 기니피그를 키우세요!\n기니피그 이름을 지어줄래요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.showInputPopup()
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
    }
    
    func showInputPopup() {
        let inputAlertController = UIAlertController(title: "기니피그의 이름을 지어주세요!", message: "당신의 기니피그는\n이름이 무엇인가요?", preferredStyle: .alert)

        inputAlertController.addTextField { textField in
            textField.placeholder = "ex) 기니, 뿡뿡이, 밤톨"
        }

        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
            if let text = inputAlertController.textFields?.first?.text, !text.isEmpty {
                self?.giniName.text = text
            } else {
                self?.giniName.text = "기니피그"
            }
        }
        inputAlertController.addAction(saveAction)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        inputAlertController.addAction(cancelAction)

        present(inputAlertController, animated: true, completion: nil)
    }

}






