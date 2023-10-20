//
//  RewardPageViewController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit
import SnapKit

class RewardPageViewController: UIViewController {
    
    lazy var plusButton:UIButton = {
        let button = UIButton()
        button.setTitle("+1", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
        button.backgroundColor = .yellow
        return button
    }()
    lazy var minusButton:UIButton = {
        let button = UIButton()
        button.setTitle("-1", for: .normal)
        button.setTitleColor(UIColor(named: "theme01PointColor03"), for: .normal)
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
        label.textColor = .black
        return label
        
        
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "theme01PointColor02")
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
            make.centerX.equalToSuperview().offset(Constant.screenWidth * 0.01)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(giniimageView.snp.bottom).offset(Constant.screenHeight * 0.01)
            make.centerX.equalToSuperview().inset(Constant.screenWidth * 0.01)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    func setuplabel(){
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
    }
    
}




