import SafariServices
import UIKit

class PrivacyPolicyViewController: UIViewController, SFSafariViewControllerDelegate {
    let privacyPolicyURL = URL(string: "https://plip.kr/pcc/9c14aedc-b05b-486f-a776-dae9bd84b62a/privacy/2.html")!

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension PrivacyPolicyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "개인정보처리방침"
        
        let safariViewController = SFSafariViewController(url: privacyPolicyURL)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
}
