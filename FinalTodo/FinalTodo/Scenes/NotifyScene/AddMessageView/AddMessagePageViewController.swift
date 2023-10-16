import SnapKit
import UIKit

class AddMessagePageViewController: UIViewController {
//    lazy var messageTextView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 20)
//        textView.isScrollEnabled = false
//        textView.backgroundColor = ColorManager.themeArray[0].pointColor02
//        textView.delegate = self
//        return textView
//    }()

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

//        view.addSubview(messageTextView)
//
//        messageTextView.snp.makeConstraints { make in
//            let lineHeight = messageTextView.font!.lineHeight
//            messageTextView.snp.makeConstraints { make in
//                make.center.equalToSuperview()
//                make.leading.trailing.equalToSuperview().inset(20)
//                make.height.equalTo(lineHeight * 4)
//            }
//        }
    }
}

