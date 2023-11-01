import SnapKit
import UIKit

class AddMemoPageViewController: UIViewController {
    // 델리게이트 프로퍼티. 메모 추가/편집 후 이를 호출함으로써 델리게이트 객체에게 알림.
    weak var delegate: AddMemoDelegate?
    var currentMemoId: String? // 현재 편집중인 메모의 ID (nil이면 새 메모)
    var selectedFolderId: String? // 사용자가 선택한 폴더의 ID

    let topView = ModalTopView(title: "메모 추가하기")
    let memoView = MemoView()
    let viewModel = AddMemoPageViewModel()

    lazy var savebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
}

extension AddMemoPageViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
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
        // 성준 - 완료 버튼 추가
        view.addSubview(savebutton)
        savebutton.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.left.equalTo(topView.snp.left).offset(15)
        }
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

    @objc func didTapSaveButton() {
        guard let content = memoView.contentTextView.text, !content.isEmpty else {
            print("메모 내용이 없습니다.")
            return
        }
        // 현재 날짜를 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())

        // 선택된 알림 날짜와 시간을 확인하고 문자열로 변환
        var notifyDateTimeString: String?
        if let date = viewModel.selectedDate, let time = viewModel.selectedTime {
            let dateTimeFormatter = DateFormatter()
            dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            notifyDateTimeString = dateTimeFormatter.string(from: date) + " " + dateTimeFormatter.string(from: time)
            print("알림이 설정된 시간: \(notifyDateTimeString ?? "None")")
        } else {
            print("알림이 설정되지 않았습니다.")
        }

        let folderId = selectedFolderId ?? "FOLDER_ID" // 선택된 폴더의 ID 또는 기본값

        // 메모 수정 또는 새 메모 생성
        if let memoId = currentMemoId {
            // 기존 메모 업데이트 로직
            let updatedMemo = MemoData(
                id: memoId,
                folderId: folderId,
                date: dateString,
                content: content,
                isPin: false,
                locationNotifySetting: "",
                timeNotifySetting: notifyDateTimeString
            )
            // CoreDataManager를 사용하여 CoreData에서 메모 업데이트
            CoreDataManager.shared.updateMemo(updatedMemo: updatedMemo) {
                print("메모가 성공적으로 업데이트되었습니다.")
                self.delegate?.didAddMemo()
                self.dismiss(animated: true)
            }
        } else {
            // 새로운 메모 생성 로직
            let newMemo = MemoData(
                id: UUID().uuidString,
                folderId: folderId,
                date: dateString,
                content: content,
                isPin: false,
                locationNotifySetting: "",
                timeNotifySetting: notifyDateTimeString // 선택된 시간 설정을 문자열로 변환
            )
            // CoreDataManager를 사용하여 CoreData에 저장
            CoreDataManager.shared.createMemo(newMemo: newMemo) {
                print("메모가 성공적으로 저장되었습니다.")
                self.delegate?.didAddMemo()
                self.dismiss(animated: true)
            }
        }
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
        case 0: // "날짜 및 시간알림" 셀 선택 시
            vc = AddMemoMainNotifyViewController()
            (vc as? AddMemoMainNotifyViewController)?.delegate = self
        case 1: // 위치 설정을 선택한 경우
            vc = LocationSettingPageViewController()
        case 2: // 폴더 선택
            let folderSelectVC = FolderSelectPageViewController()
            folderSelectVC.delegate = self
            vc = folderSelectVC
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
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.7)
    }
}

extension AddMemoPageViewController {
    func changeCellBackground(at row: Int, to color: UIColor) {
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = memoView.optionCollectionView.cellForItem(at: indexPath) as? MemoOptionCollectionViewCell {
            // cell.changeBackgroundColor(to: color)
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
        changeCellBackground(at: 0, to: .systemGray3)
    }

    func didResetDateSetting() {
        changeCellBackground(at: 0, to: .secondarySystemBackground)
    }
}

extension AddMemoPageViewController: NotifySettingDelegate {
    func didCompleteNotifySetting() {
        // 두 번째 셀(시간 설정)에 대한 배경색을 변경
        changeCellBackground(at: 1, to: .secondarySystemBackground)
    }

    func didResetNotifySetting() {
        changeCellBackground(at: 1, to: .secondarySystemBackground)
    }
}

extension AddMemoPageViewController {
    // 메모 데이터를 불러와서 UI에 반영하는 메서드
    func loadMemoData(memo: MemoData) {
        memoView.contentTextView.text = memo.content
        currentMemoId = memo.id
        selectedFolderId = memo.folderId // 폴더 ID도 로드
    }
}

extension AddMemoPageViewController: FolderSelectDelegate {
    // 폴더 선택이 완료되었을 때의 콜백
    func didSelectFolder(folderId: String) {
        // 선택된 폴더의 ID 저장
        selectedFolderId = folderId
    }
}

extension AddMemoPageViewController: AddMemoMainNotifyViewControllerDelegate {
    func didReserveNotification(date: Date, time: Date) {
        // 알림이 예약되었을 때 수행할 로직
        viewModel.selectedDate = date
        viewModel.selectedTime = time
    }
}
