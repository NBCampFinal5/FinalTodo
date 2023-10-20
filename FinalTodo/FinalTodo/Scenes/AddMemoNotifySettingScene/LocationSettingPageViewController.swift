import UIKit

class LocationSettingPageViewController: UIViewController {
    
    private let topView = ModalTopView(title: "위치 설정")
}

extension LocationSettingPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension LocationSettingPageViewController {
    func setUp() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        setUpTopView()
    }

    private func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
}
