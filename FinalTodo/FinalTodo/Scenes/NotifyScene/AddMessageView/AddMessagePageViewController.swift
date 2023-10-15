import SnapKit
import UIKit

class AddMessagePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTappedDoneButton))
        doneButton.tintColor = .black
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func didTappedDoneButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AddMessagePageViewController {
    func setup() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        title = "메세지 설정"
    }
}
