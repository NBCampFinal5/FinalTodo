import FSCalendar
import SnapKit
import UIKit

// MARK: - view 선언방식 이유가 필요할 듯

class CalendarPageViewController: UIViewController {
    let manager = CoreDataManager.shared

    // 선택된 D-day 날짜
    var selectedDdays: [Date] = []
    var calendarView: CalendarPageView!

    var isModalDismissed: Bool = false {
        didSet { self.calendarView.calendar.reloadData()
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
}

extension CalendarPageViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // 날짜 선택 시 호출
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(calendarView.dateFormatter.string(from: date) + " 선택됨")

        let calendarListVC = CalendarListViewController(date: calendarView.dateFormatter.string(from: date))
        calendarListVC.onDismiss = { [weak self] in self?.isModalDismissed = true }
        calendarListVC.modalPresentationStyle = .custom
        calendarListVC.transitioningDelegate = self
        present(calendarListVC, animated: true)

        calendarView.calendar.deselect(date)
    }

    // 날짜 선택 해제 시 호출
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(calendarView.dateFormatter.string(from: date) + " 해제됨")
        calendarView.calendar.reloadData()
    }

    // 특정 날짜에 표시될 서브타이틀을 결정 ("D-day", "오늘")
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        for dday in selectedDdays {
            // 현재 날짜와 D-day 날짜 간의 차이 계산
            let difference = Calendar.current.dateComponents([.day], from: Date().startOfDay, to: dday)
            // daysDifference는 두 날짜 간의 차이 일수
            if let daysDifference = difference.day {
                switch daysDifference {
                case 0: // D-day와 현재 날짜가 같을 경우
                    if Calendar.current.isDate(date, inSameDayAs: dday) {
                        return "D-day"
                    }
                case 1...: // D-day가 현재 날짜보다 미래일 경우
                    if Calendar.current.isDate(date, inSameDayAs: dday) {
                        return "D-\(daysDifference)"
                    }
                case ..<0: // D-day가 현재 날짜보다 과거일 경우
                    let positiveDifference = abs(daysDifference)
                    if Calendar.current.isDate(date, inSameDayAs: dday) {
                        return "D+\(positiveDifference)"
                    }
                default:
                    break
                }
            }
        }
//        // 현재 날짜에 "오늘" 이라는 문구 나타냄
//        if calendarView.dateFormatter.string(from: date) == calendarView.dateFormatter.string(from: Date()) {
//            return "오늘"
//        }

        // 해당 날짜 알림 설정 메모 배열
        let notifyMemos = manager.getMemos().filter {
            if let notifyDate = $0.timeNotifySetting {
                if String(notifyDate).prefix(10) == calendarView.dateFormatter.string(from: date) {
                    return true
                }
                return false
            }
            return false
        }

        // 해당 날짜 알림 설정 메모가 있다면 -> "●"
        if !notifyMemos.isEmpty {
            return "●"
        }

        return nil
    }

    // 날짜 선택 시 동작을 결정
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if let selectedDate = calendar.selectedDate {
            calendar.deselect(selectedDate)
        }
        return true
    }

    // 오늘 날짜 배경색 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date == Date().startOfDay {
            return .systemGray3 // 오늘 날짜 배경색
        }
        return nil
    }

    // 선택 날짜 배경색 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .systemGray3
        // return .tertiaryLabel // 선택된 날짜 배경색
    }

    // 서브타이틀 컬러 설정 - ●
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return .myPointColor
    }

    // ● 의 위치 조정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 30)
    }

    // 날짜색깔 다크모드 대응
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .label
//        let defaultColor = appearance.titleDefaultColor
//
//        if #available(iOS 12.0, *) {
//            if self.traitCollection.userInterfaceStyle == .dark {
//                return .white
//            } else {
//                return defaultColor
//            }
//        } else {
//            return defaultColor
//        }
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
