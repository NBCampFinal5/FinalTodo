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
    
    lazy var plusButton:UIButton = {
        let button = UIButton()
        button.setTitle("+1", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
        button.addTarget(self, action: #selector(increaseScore), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()
    lazy var minusButton:UIButton = {
        let button = UIButton()
        button.setTitle("-1", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
        button.addTarget(self, action: #selector(diminishScore), for: .touchUpInside)
        button.backgroundColor = .green
        return button
    }()
    
    let giniimageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "gini1")
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        return ImageView
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
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
            make.width.height.equalTo(200)
            
        }
    }
    func setupButton(){
        view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(giniimageView.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalToSuperview().offset(Constant.screenWidth * 0.3)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalToSuperview().offset(Constant.screenWidth * 0.3)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    func setuplabel(){
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.bottom.equalTo(plusButton.snp.top)
            make.centerX.equalToSuperview().offset(Constant.screenWidth * 0.3)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
}

extension RewardPageViewController {
    
    @objc func increaseScore() {
        // 버튼을 누를 때 호출되는 함수
        score += 1
        scoreLabel.text = "\(score)"
        if score >= 10 {
            giniimageView.image = UIImage(named: "gini2")
            UIView.animate(withDuration: 0.5, animations: {
                self.giniimageView.transform = CGAffineTransform(scaleX: 2, y: 2) // 이미지 확대
            })
        }
    }
    @objc func diminishScore() {
        // 버튼을 누를 때 호출되는 함수
        if score > 0 {
            score -= 1
            scoreLabel.text = "\(score)"
            
            if score < 10 {
                giniimageView.image = UIImage(named: "gini1")
                UIView.animate(withDuration: 0.5, animations: {
                    self.giniimageView.transform = .identity // 이미지 원래 크기로
                })
            }
        }
    }
}






