import FSCalendar
import SnapKit
import UIKit

// MARK: - view 선언방식 이유가 필요할 듯

class CalendarPageViewController: UIViewController {
    let manager = CoreDataManager.shared

    // 선택된 D-day 날짜
    var selectedDdays: [Date] = []
    var calendarView: CalendarPageView!
    lazy var timesAry: [String] = []
    
    var isModalDismissed: Bool = false {
        didSet {
            makeTimesAry()
            self.calendarView.calendar.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView = CalendarPageView(frame: view.bounds)
        view.addSubview(calendarView)
        view.backgroundColor = .secondarySystemBackground
        calendarView.backgroundColor = .secondarySystemBackground
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self

        calendarView.todayButton.addTarget(self, action: #selector(didTapTodayButton), for: .touchUpInside)

        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        calendarView.calendar.reloadData()
        setCalendarUI()
        navigationController?.configureBar()
        tabBarController?.configureBar()
        makeTimesAry()
    }

    // 네비게이션 바 설정
    private func setupNavigationBar() {
        navigationItem.title = "캘린더"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondarySystemBackground]
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    // D-day 버튼 터치 시 호출
    @objc func didTapDdayButton() {
        let vc = DdayPageViewController()
        vc.completion = { [weak self] date in
            self?.selectedDdays.append(date)
            self?.calendarView.calendar.reloadData()
        }
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = self

        present(navController, animated: true, completion: nil)
    }

    // 오늘 버튼 터치 시 호출
    @objc func didTapTodayButton() {
        calendarView.calendar.setCurrentPage(Date(), animated: true)
    }
    
    func makeTimesAry() {
        timesAry = manager.getMemos().compactMap({$0.timeNotifySetting}).map{$0.replacingOccurrences(of: ".", with: "-").prefix(10)}.map{String($0)}
    }
}

extension CalendarPageViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // 날짜 선택 시 호출
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(calendarView.dateFormatter.string(from: date) + " 선택됨")
        let nowDate = String(calendarView.dateFormatter.string(from: date).replacingOccurrences(of: "-", with: ".").prefix(10))
        let calendarListVC = CalendarListViewController(date: nowDate)
        calendarListVC.onDismiss = { [weak self] in
            guard let self = self else { return }
            self.isModalDismissed = true
            DispatchQueue.main.async {
                self.calendarView.calendar.deselect(date)
            }
            
        }
        calendarListVC.modalPresentationStyle = .custom
        calendarListVC.transitioningDelegate = self
        present(calendarListVC, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let nowDate = calendarView.dateFormatter.string(from: date)
        if timesAry.contains(nowDate) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.myPointColor]
    }

    // 오늘 날짜 배경색 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date == Date().startOfDay {
            return .systemGray // 오늘 날짜 배경색
        }
        return nil
    }

    // 선택 날짜 배경색 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .systemGray4
    }

    // 날짜색깔 다크모드 대응
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .label
    }

    func setCalendarUI() {
        calendarView.calendar.appearance.headerTitleColor = .myPointColor
        calendarView.calendar.appearance.weekdayTextColor = .label
    }
}

extension CalendarPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
    }
}
