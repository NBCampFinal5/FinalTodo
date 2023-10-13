import UIKit

class AddNotifyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension AddNotifyViewController {
    func setup() {
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        title = "시간 설정"
    }
}
