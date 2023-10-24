import SnapKit
import UIKit

class AddMemoMainNotifyViewController: UIViewController {
    let viewModel = AddMemoPageViewModel()
    let topView = ModalTopView(title: "날짜 및 시간 알림")

    var settingOptionData: [[SettingOption]] = [
        [
            SettingOption(icon: "calendar", title: "날짜", showSwitch: false, isOn: false),
            SettingOption(icon: "clock", title: "시간", showSwitch: false, isOn: false),
        ],
    ]

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapDateTooltip), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        setUpTopView()
        setUpTableView()
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.backgroundColor = ColorManager.themeArray[0].backgroundColor
        tableView.rowHeight = Constant.screenWidth / 10

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setUpTopView() {
        view.addSubview(topView)
        view.addSubview(infoButton)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        infoButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Constant.defaultPadding)
        }
    }

    @objc func didTapBackButton() {
        dismiss(animated: true)
    }

    @objc func didTapDateTooltip() {
        let alertController = UIAlertController(title: "알림 설정", message: "날짜알림만 설정시 오전 9시에 알림이 옵니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

extension AddMemoMainNotifyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingOptionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptionData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        let model = settingOptionData[indexPath.section][indexPath.row]
        cell.configure(with: model)
        cell.backgroundColor = ColorManager.themeArray[0].pointColor02
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var vc: UIViewController!
        if indexPath.row == 0 {
            vc = DateSettingPageViewController(viewModel: viewModel) // "날짜" 셀 선택 시
        } else {
            vc = NotifySettingPageViewController(viewModel: viewModel, initialTime: viewModel.selectedTime) // "시간" 셀 선택 시
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}


extension AddMemoMainNotifyViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.6)
    }
}
