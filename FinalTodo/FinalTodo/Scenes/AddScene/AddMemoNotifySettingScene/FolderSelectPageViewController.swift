import SnapKit
import UIKit
import UserNotifications

protocol FolderSelectDelegate: AnyObject {
    func didSelectFolder(folderId: String)
}

class FolderSelectPageViewController: ModalPossibleGestureController {
    weak var delegate: FolderSelectDelegate?
    let topView = ModalTopView(title: "폴더 선택")
    let tableView = UITableView() // 폴더 목록을 보여줄 테이블뷰
//    let viewModel = MainPageViewModel() // 폴더 데이터를 가져오기 위한 뷰모델
    let viewModel: AddMemoPageViewModel
    
    var handler: () -> Void = {}
    
    init(viewModel: AddMemoPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FolderSelectPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        handler()
    }
}

extension FolderSelectPageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        setUpTopView()
        setUpTableView()
    }

    private func setUpTopView() {
        view.addSubview(topView)

        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        topView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FolderCell")
    }

    // 뒤로가기 버튼 동작
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
}

extension FolderSelectPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coredataManager.getFolders().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        let folder = viewModel.coredataManager.getFolders()[indexPath.row]
        if viewModel.optionImageAry[2] == folder.title {
            cell.textLabel?.textColor = .red
        }
        cell.textLabel?.text = folder.title
        cell.backgroundColor = .secondarySystemBackground
        print(indexPath.row, cell.isSelected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = viewModel.coredataManager.getFolders()[indexPath.row]
        viewModel.optionImageAry[2] = folder.title
        delegate?.didSelectFolder(folderId: folder.id)
        dismiss(animated: true)
        // TODO: 폴더 선택 완료 동작 구현
    }
}
