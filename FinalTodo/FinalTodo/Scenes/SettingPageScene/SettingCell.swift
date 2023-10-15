import SnapKit
import UIKit

class SettingCell: UITableViewCell {
    // 스택뷰: 디폴트값 .horizontal
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constant.defaultPadding
        stackView.alignment = .center
        return stackView
    }()

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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(cellSwitch)
         
        stackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }
         
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 15)
        }

    }
    
    func configure(with option: SettingOption) {
        iconImageView.image = UIImage(systemName: option.icon)
        titleLabel.text = option.title
        
        // 성준 - 푸시 알림 셀 스위치만 따로 설정, 서령 - UI 변경으로 코드 변경
        if option.title == "푸시 알림" {
            cellSwitch.isHidden = false
        } else {
            cellSwitch.isHidden = true
        }
    }

    // 성준 - 스위치 on / off 시 설정
    @objc private func didTappedSwitch(sender: UISwitch) {
        print("스위치 \(sender.isOn ? "ON" : "OFF")")
    }
}
