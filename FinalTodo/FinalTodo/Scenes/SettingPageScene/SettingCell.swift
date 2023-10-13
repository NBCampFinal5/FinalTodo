import SnapKit
import UIKit

class SettingCell: UITableViewCell {
//    let identifier = #function
//    // #function: 현재 위치에서 사용 중인 함수 또는 메서드의 이름을 나타내는 키워드
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tertiaryLabel
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    private let cellSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isHidden = true
        switchControl.addTarget(self, action: #selector(didTappedSwitch), for: .valueChanged)
        return switchControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(cellSwitch) // 성준 - 셀 스위치
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Constant.screenWidth / 15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(Constant.defaultPadding)
            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Constant.screenWidth / 15)
        }
        
        // 성준 - 셀 스위치 레이아웃
        cellSwitch.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }
    }
    
    func configure(with option: SettingOption) {
        iconImageView.image = UIImage(systemName: option.icon)
        titleLabel.text = option.title
        
        // 성준 - 푸시 알림 셀 스위치만 따로 설정
        if option.title == "푸시 알림" {
            chevronImageView.isHidden = true
            cellSwitch.isHidden = false
        } else {
            chevronImageView.isHidden = false
            cellSwitch.isHidden = true
        }
    }
    // 성준 - 스위치 on / off 시 설정
    @objc private func didTappedSwitch(sender: UISwitch) {
        print("스위치 \(sender.isOn ? "ON" : "OFF")")
    }
}
