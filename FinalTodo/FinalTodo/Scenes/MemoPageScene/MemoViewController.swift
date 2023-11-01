import SnapKit
import UIKit

// 새 메모를 추가하거나 기존 메모를 편집할 때 호출되는 델리게이트 프로토콜
// protocol AddMemoDelegate: AnyObject {
//    func didAddMemo()
// }

class MemoViewController: UIViewController {
    // 델리게이트 프로퍼티. 메모 추가/편집 후 이를 호출함으로써 델리게이트 객체에게 알림.
    weak var delegate: AddMemoDelegate?
    var currentMemoId: String? // 현재 편집중인 메모의 ID (nil이면 새 메모)
    var selectedFolderId: String? // 사용자가 선택한 폴더의 ID

    let memoView = MemoView()
    let viewModel = AddMemoPageViewModel()
}

extension MemoViewController {
    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        if selectedFolderId! != "allNote" {
            let folders = viewModel.coredataManager.getFolders()
            let folder = folders.filter({$0.id == selectedFolderId!}).first!
            viewModel.optionImageAry[2] = folder.title
        }
        if currentMemoId != nil {
            let memo = viewModel.coredataManager.getMemos().filter({$0.id == currentMemoId!}).first!
            if memo.timeNotifySetting! != "" {
                viewModel.optionImageAry[0] = memo.timeNotifySetting!
                print(memo.timeNotifySetting)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
    }
}

private extension MemoViewController {
    // MARK: - setUp

    func setUp() {
        setUpMemoView()
        setupNavigationBar()
    }

    func setUpMemoView() {
        view.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        memoView.contentTextView.delegate = self
        memoView.optionCollectionView.delegate = self
        memoView.optionCollectionView.dataSource = self
    }

    func setupNavigationBar() {

        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem = saveButton

        // "뒤로" 버튼에 대한 액션 설정
        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
    }
}

extension MemoViewController {
    @objc func didTapSaveButton() {
        guard let content = memoView.contentTextView.text, !content.isEmpty else {
            print("메모 내용이 없습니다.")
            return
        }

        // 현재 날짜를 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())

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
                timeNotifySetting: ""
            )
            // CoreDataManager를 사용하여 CoreData에서 메모 업데이트
            CoreDataManager.shared.updateMemo(updatedMemo: updatedMemo) {
                print("메모가 성공적으로 업데이트되었습니다.")
                self.delegate?.didAddMemo()
                // self.dismiss(animated: true)
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
                timeNotifySetting: ""
            )
            // CoreDataManager를 사용하여 CoreData에 저장
            CoreDataManager.shared.createMemo(newMemo: newMemo) {
                print("메모가 성공적으로 저장되었습니다.")
                self.delegate?.didAddMemo()
                // self.dismiss(animated: true)
            }
        }
    }

    @objc func didTapBackButton() {
        guard let content = memoView.contentTextView.text, !content.isEmpty else {
            print("메모 내용이 없습니다.")
            return
        }

        // 현재 날짜를 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())

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
                timeNotifySetting: ""
            )
            // CoreDataManager를 사용하여 CoreData에서 메모 업데이트
            CoreDataManager.shared.updateMemo(updatedMemo: updatedMemo) {
                print("메모가 성공적으로 업데이트되었습니다.")
                self.delegate?.didAddMemo()
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
                timeNotifySetting: ""
            )
            // CoreDataManager를 사용하여 CoreData에 저장
            CoreDataManager.shared.createMemo(newMemo: newMemo) {
                print("메모가 성공적으로 저장되었습니다.")
                self.delegate?.didAddMemo()
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension MemoViewController: UITextViewDelegate {
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

extension MemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
                
            }
        case 2:
            if selectedFolderId! != "allNote"{
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
            let vc = LocationSettingPageViewController()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: nil)
        case 2: // 폴더 선택
            let vc = FolderSelectPageViewController(viewModel: viewModel)
            vc.delegate = self
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

extension MemoViewController: UICollectionViewDelegateFlowLayout {
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

extension MemoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.7)
    }
}

extension MemoViewController {
    func changeCellBackground(at row: Int, to color: UIColor) {
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = memoView.optionCollectionView.cellForItem(at: indexPath) as? MemoOptionCollectionViewCell {
            //cell.changeBackgroundColor(to: color)
        } else {
            // 셀이 화면에 보이지 않는 경우 collectionView를 다시 로드하여 UI 업데이트
            memoView.optionCollectionView.reloadData()
        }
    }
}

extension MemoViewController: DateSettingDelegate {
    func didCompleteDateSetting(date: Date) {
        // 선택된 날짜를 viewModel의 selectedDate에 저장
        viewModel.selectedDate = date
        // 첫 번째 셀(날짜 설정)에 대한 배경색을 변경
        changeCellBackground(at: 0, to: .systemYellow)
    }

    func didResetDateSetting() {
        changeCellBackground(at: 0, to: .secondarySystemBackground)
    }
}

extension MemoViewController: NotifySettingDelegate {
    func didCompleteNotifySetting() {
        // 두 번째 셀(시간 설정)에 대한 배경색을 변경
        changeCellBackground(at: 1, to: .secondarySystemBackground)
    }

    func didResetNotifySetting() {
        changeCellBackground(at: 1, to: .secondarySystemBackground)
    }
}

extension MemoViewController {
    // 메모 데이터를 불러와서 UI에 반영하는 메서드
    func loadMemoData(memo: MemoData) {
        memoView.contentTextView.text = memo.content
        currentMemoId = memo.id
        selectedFolderId = memo.folderId // 폴더 ID도 로드
    }
}

extension MemoViewController: FolderSelectDelegate {
    // 폴더 선택이 완료되었을 때의 콜백
    func didSelectFolder(folderId: String) {
        // 선택된 폴더의 ID 저장
        selectedFolderId = folderId
    }
}
