import SnapKit
import UIKit

class AddMemoPageViewController: ModalPossibleGestureController {
    // 델리게이트 프로퍼티. 메모 추가/편집 후 이를 호출함으로써 델리게이트 객체에게 알림.
    weak var delegate: AddMemoDelegate?
    var currentMemoId: String? // 현재 편집중인 메모의 ID (nil이면 새 메모)
    var selectedFolderId: String? // 사용자가 선택한 폴더의 ID
    var keyboardHeight: CGFloat = 0 // 성준 - 키보드 높이를 저장할 프로퍼티
    
    let topView = ModalTopView(title: "메모 추가하기")
    let memoView = MemoView()
    let viewModel = AddMemoPageViewModel()
    
    lazy var savebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.myPointColor, for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
}

// MARK: - LifeCycle

extension AddMemoPageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if selectedFolderId! != "allNote" {
            let folders = viewModel.coredataManager.getFolders()
            viewModel.optionImageAry[2] = folders.filter { $0.id == selectedFolderId! }.first!.title
        }
        // 시간 알림 설정을 확인하고 적용
        if let timeNotifySetting = viewModel.timeNotifySetting, !timeNotifySetting.isEmpty {
            viewModel.optionImageAry[0] = timeNotifySetting
        } else if let memoId = currentMemoId {
            let memos = viewModel.coredataManager.getMemos()
            if let memo = memos.filter({ $0.id == memoId }).first, let timeNotifySetting = memo.timeNotifySetting, !timeNotifySetting.isEmpty {
                viewModel.timeNotifySetting = timeNotifySetting
                viewModel.optionImageAry[0] = timeNotifySetting
                print("알림설정 시간: \(timeNotifySetting)")
            }
        }
        // 위치 알림 설정을 확인하고 적용
        if let locationSetting = viewModel.locationNotifySetting, !locationSetting.isEmpty {
            viewModel.optionImageAry[1] = locationSetting
        }
        // 셀의 배경색을 업데이트
        memoView.optionCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUp()
    }
}

// MARK: - setUp

private extension AddMemoPageViewController {
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
}

// MARK: - Method

extension AddMemoPageViewController {
    @objc func didTappedBackButton() {
        dismiss(animated: true)
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
                locationNotifySetting: viewModel.locationNotifySetting,
                timeNotifySetting: viewModel.timeNotifySetting
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
                locationNotifySetting: viewModel.locationNotifySetting,
                timeNotifySetting: viewModel.timeNotifySetting
            )
            // CoreDataManager를 사용하여 CoreData에 저장
            CoreDataManager.shared.createMemo(newMemo: newMemo) {
                print("메모가 성공적으로 저장되었습니다.")
                self.delegate?.didAddMemo()
                self.dismiss(animated: true)
            }
        }
    }
    
    // 성준 - 키보드가 나타날 때 호출될 메서드
    @objc func keyboardWillShow(notification: NSNotification) {
        // 키보드의 높이 정보를 담고 있는 값을 NSNotification 객체로부터 추출
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // NSValue 객체를 CGRect로 변환하여 실제 키보드의 크기를 얻음
            let keyboardRealFrame = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRealFrame.height
            // 텍스트 뷰의 하단 contentInset을 키보드의 높이만큼 설정하여 키보드에 의해 가려지지 않게함
            memoView.contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            // 스크롤 바(indicator)의 여백도 동일하게 설정합니다.
            memoView.contentTextView.scrollIndicatorInsets = memoView.contentTextView.contentInset
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 contentInset과 scrollIndicatorInsets을 기본 값(0)으로 되돌려 텍스트 뷰를 원래 위치로 되돌림
        memoView.contentTextView.contentInset = .zero
        memoView.contentTextView.scrollIndicatorInsets = .zero
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
    
    func textViewDidChange(_ textView: UITextView) {
        // 현재 커서의 위치를 계산하기 위한 변수를 선언
        var cursorPosition: CGRect?
        // 현재 선택된 텍스트 범위를 가져옴
        if let selectedRange = textView.selectedTextRange {
            // 커서는 선택된 텍스트의 끝에 위치
            cursorPosition = textView.caretRect(for: selectedRange.end)
        }
        // 옵셔널 바인딩을 통해 cursorPosition이 nil이 아닌 경우에만 내부 블록을 실행
        if let cursorRect = cursorPosition {
            // 커서의 위치를 텍스트뷰 내부 좌표계로 변환
            var cursorRectInTextView = textView.convert(cursorRect, to: textView)
            // 커서와 키보드 사이에 추가적인 여백을 주기 위해 padding 값
            let padding: CGFloat = 20
            cursorRectInTextView.origin.y += padding
            // 텍스트 뷰의 실제 보이는 영역을 계산
            let textViewRect = textView.bounds.inset(by: textView.contentInset)
            // 만약 커서가 보이는 영역 밖에 있다면 텍스트 뷰를 스크롤하여 커서를 보이는 위치로 이동
            if !textViewRect.contains(cursorRectInTextView) {
                textView.scrollRectToVisible(cursorRectInTextView, animated: true)
            }
        }
    }
}

extension AddMemoPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.optionImageAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoOptionCollectionViewCell.identifier, for: indexPath) as! MemoOptionCollectionViewCell
        cell.contentView.backgroundColor = .systemBackground
        cell.contentView.layer.borderColor = UIColor.label.cgColor
        cell.categoryLabel.textColor = .label
        switch indexPath.row {
        case 0:
            if viewModel.selectedTime != nil {
                cell.contentView.backgroundColor = .myPointColor
                cell.categoryLabel.textColor = .systemBackground
                print("here")
            }
        case 1:
            if viewModel.locationNotifySetting != nil {
                cell.contentView.backgroundColor = .myPointColor
                cell.categoryLabel.textColor = .systemBackground
                print("here")
            }
        case 2:
            if selectedFolderId! != "allNote" {
                cell.contentView.backgroundColor = .myPointColor
                cell.categoryLabel.textColor = .systemBackground
            }
        default:
            cell.contentView.backgroundColor = .systemBackground
            cell.contentView.layer.borderColor = UIColor.label.cgColor
            cell.categoryLabel.textColor = .label
            print("default")
        }
        cell.bind(title: viewModel.optionImageAry[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        // 사용자에게 보여질 뷰 컨트롤러를 저장하기 위한 임시 변수를 선언
        
        switch indexPath.row {
        case 0: // "날짜 및 시간알림" 셀 선택 시
            let vc = AddMemoMainNotifyViewController(viewModel: viewModel)
            vc.handler = { [weak self] in
                self?.memoView.optionCollectionView.reloadData()
            }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: nil)
        case 1: // 위치 설정을 선택한 경우
            let vc = LocationSettingPageViewController(viewModel: viewModel)
            vc.delegate = self
            vc.handler = { [weak self] in
                self?.memoView.optionCollectionView.reloadData()
            }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: nil)
        case 2: // 폴더 선택
            let folderSelectVC = FolderSelectPageViewController(viewModel: viewModel)
            folderSelectVC.delegate = self
            let vc = folderSelectVC
            vc.handler = { [weak self] in
                self?.memoView.optionCollectionView.reloadData()
            }
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: nil)
        default:
            break
        }
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

extension AddMemoPageViewController: LocationSettingDelegate {
    func didCompleteLocationSetting(location: String) {
        viewModel.locationNotifySetting = location
        changeCellBackground(at: 1, to: .secondarySystemBackground)
    }
    
    func didResetLocationSetting() {
        changeCellBackground(at: 1, to: .secondarySystemBackground)
    }
}

extension AddMemoPageViewController: NotifySettingDelegate {
    func didResetTimeSetting() {
        //
    }
    
    func didCompleteTimeSetting(time: Date) {
        //
    }
    
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
