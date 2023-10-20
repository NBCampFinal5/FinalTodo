import SnapKit
import UIKit

class AddMemoPageViewController: UIViewController {
    let topView = ModalTopView(title: "메모 추가하기")
    let memoView = MemoView()
    let viewModel = AddMemoPageViewModel()
}

extension AddMemoPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.themeArray[0].backgroundColor
        setUp()
    }
}

private extension AddMemoPageViewController {
    // MARK: - setUp

    func setUp() {
        setUpTopView()
        setUpMemoView()
    }

    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
    }

    func setUpMemoView() {
        view.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(Constant.defaultPadding)
            make.left.right.bottom.equalToSuperview()
        }
        memoView.contentTextView.delegate = self
        memoView.optionCollectionView.delegate = self
        memoView.optionCollectionView.dataSource = self
    }
}

extension AddMemoPageViewController {
    // MARK: - Method

    @objc func didTappedBackButton() {
        dismiss(animated: true)
    }
}

extension AddMemoPageViewController: UITextViewDelegate {
    // MARK: - TextViewPlaceHolder

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "메모를 입력해 주세요." {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            textView.text = "메모를 입력해 주세요."
            textView.textColor = .systemGray
        }
        return true
    }
}

extension AddMemoPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.optionImageAry.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoOptionCollectionViewCell.identifier, for: indexPath) as! MemoOptionCollectionViewCell
        cell.bind(title: viewModel.optionImageAry[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)

        // 사용자에게 보여질 뷰 컨트롤러를 저장하기 위한 임시 변수를 선언
        var vc: UIViewController!

        switch indexPath.row {
        case 0:
            let dateSettingVC = DateSettingPageViewController(viewModel: viewModel)
            // 현재 뷰 컨트롤러를 delegate로 설정하여, 날짜 설정 완료 시 콜백을 받을 수 있게 함
            dateSettingVC.delegate = self
            // viewModel에 저장된 선택된 날짜가 있다면, 해당 날짜를 뷰 컨트롤러의 초기 날짜로 설정
            if let selectedDate = viewModel.selectedDate {
                dateSettingVC.initialDate = selectedDate
            }
            vc = dateSettingVC // 임시 변수 vc에 해당하는 뷰 컨트롤러
        case 1:
            let notifySettingVC = NotifySettingPageViewController(viewModel: viewModel, initialTime: viewModel.selectedTime)
            notifySettingVC.delegate = self
            vc = notifySettingVC // 임시 변수 vc에 해당하는 뷰 컨트롤러
        case 2:
            let locationSettingVC = LocationSettingPageViewController()
            vc = locationSettingVC // 임시 변수 vc에 해당하는 뷰 컨트롤러
        default:
            break
        }

        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension AddMemoPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leadingTrailingInset: CGFloat = 10
        let cellHeight: CGFloat = Constant.screenHeight * 0.03

        let category = viewModel.optionImageAry[indexPath.row]
        let size: CGSize = .init(width: collectionView.frame.width - 10, height: cellHeight)
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]

        let estimatedFrame = category.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let cellWidth: CGFloat = estimatedFrame.width + (leadingTrailingInset * 2)

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension AddMemoPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.6)
    }
}

extension AddMemoPageViewController {
    func changeCellBackground(at row: Int, to color: UIColor) {
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = memoView.optionCollectionView.cellForItem(at: indexPath) as? MemoOptionCollectionViewCell {
            cell.changeBackgroundColor(to: color)
        } else {
            // 셀이 화면에 보이지 않는 경우 collectionView를 다시 로드하여 UI 업데이트
            memoView.optionCollectionView.reloadData()
        }
    }
}

extension AddMemoPageViewController: DateSettingDelegate {
    func didCompleteDateSetting(date: Date) {
        // 선택된 날짜를 viewModel의 selectedDate에 저장
        viewModel.selectedDate = date
        // 첫 번째 셀(날짜 설정)에 대한 배경색을 변경
        changeCellBackground(at: 0, to: .systemYellow)
    }

    func didResetDateSetting() {
        changeCellBackground(at: 0, to: ColorManager.themeArray[0].pointColor02!)
    }
}

extension AddMemoPageViewController: NotifySettingDelegate {
    func didCompleteNotifySetting() {
        // 두 번째 셀(시간 설정)에 대한 배경색을 변경
        changeCellBackground(at: 1, to: .systemYellow)
    }

    func didResetNotifySetting() {
        changeCellBackground(at: 1, to: ColorManager.themeArray[0].pointColor02!)
    }
}
