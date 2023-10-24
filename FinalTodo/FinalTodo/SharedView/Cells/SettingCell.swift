import SnapKit
import UIKit

class SettingCell: UITableViewCell {
    weak var delegate: SettingCellDelegate? // 성준 - 델리게이트 프로퍼티 추가

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

    // 성준 - 셀 스위치
    let cellSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isHidden = true
        switchControl.addTarget(self, action: #selector(didTappedSwitch), for: .valueChanged)
        return switchControl
    }()

    // 성준 - 시간 표시 라벨
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
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
//       contentView.addSubview(timeLabel) // 성준 - 시간 표시 라벨

        stackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constant.screenWidth / 15)
        }

        // 성준 - 셀 스위치 레이아웃
        cellSwitch.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-Constant.defaultPadding)
            make.centerY.equalTo(contentView)
        }

        // 성준 - 시간표시 라벨 레이아웃
//        timeLabel.snp.makeConstraints { make in
//            make.right.equalTo(chevronImageView.snp.left).offset(-Constant.defaultPadding)
//            make.centerY.equalTo(contentView)
//        }
    }

    func configure(with option: SettingOption) {
        iconImageView.image = UIImage(systemName: option.icon)
        titleLabel.text = option.title
        cellSwitch.isHidden = !option.showSwitch
        cellSwitch.isOn = option.isOn
    }

    // 성준 - 스위치 on / off 시 설정
    @objc private func didTappedSwitch(sender: UISwitch) {
        delegate?.didChangeSwitchState(self, isOn: sender.isOn)
        print("스위치 \(sender.isOn ? "ON" : "OFF")")
    }
}
