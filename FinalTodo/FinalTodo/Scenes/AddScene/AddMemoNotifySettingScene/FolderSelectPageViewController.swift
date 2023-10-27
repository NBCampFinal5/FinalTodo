import SnapKit
import UIKit
import UserNotifications

class FolderSelectPageViewController: UIViewController {
    let topView = ModalTopView(title: "폴더 선택")
}

extension FolderSelectPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension FolderSelectPageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        setUpTopView()
    }

    private func setUpTopView() {
        view.addSubview(topView)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    // 뒤로가기 버튼 동작
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
}
