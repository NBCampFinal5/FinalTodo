import FSCalendar
import SnapKit
import UIKit

class CalendarPageViewController: UIViewController {
    // 날짜 형식을 변환하기 위한 dateFormatter
    let dateFormatter = DateFormatter()
    // 선택된 D-day 날짜
    var selectedDday: Date?

    // 오늘 날짜로 돌아오는 버튼
    lazy var todayButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTappedTodayButton), for: .touchUpInside)
        return button
    }()

    // FSCalendar 캘린더 생성
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scrollEnabled = true
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.dataSource = self
        calendar.delegate = self
        return calendar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dateFormatter.dateFormat = "yyyy-MM-dd"

        setup()
        setupNavigationBar()
    }

    // 네비게이션 바 설정
    private func setupNavigationBar() {
        let ddayButton = UIBarButtonItem(title: "D-day", style: .plain, target: self, action: #selector(didTappedDdayButton))
        navigationItem.rightBarButtonItem = ddayButton
        ddayButton.tintColor = .black
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    // D-day 버튼 터치 시 호출
    @objc func didTappedDdayButton() {
        let vc = DdayPageViewController()
        vc.completion = { [weak self] date in
            self?.selectedDday = date
            self?.calendar.reloadData()
        }
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalPresentationStyle = .pageSheet
//        if let sheetPresentationController = navController.sheetPresentationController {
//            sheetPresentationController.prefersGrabberVisible = true
//            sheetPresentationController.detents = [.medium()] // 화면에 중간 높이 설정
//            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
//        }
//        present(navController, animated: true)
    }

    // 오늘 버튼 터치 시 호출
    @objc func didTappedTodayButton() {
        calendar.setCurrentPage(Date(), animated: true)
    }
}

extension CalendarPageViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // 날짜 선택 시 호출
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 선택됨")
    }

    // 날짜 선택 해제 시 호출
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 해제됨")
    }

    // 특정 날짜에 표시될 서브타이틀을 결정 ("D-day", "오늘")
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if let dday = selectedDday {
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
        // 현재 날짜에 "오늘" 이라는 문구 나타냄
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "오늘"
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
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        if date == Date().startOfDay {
//            return UIColor(hex: "405B2B") // 오늘 날짜 배경색
//        }
//        return nil
//    }
//
//    // 선택 날짜 배경색 설정
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        return UIColor(hex: "C8D2B3") // 선택된 날짜 배경색
//    }
}

// Date 객체의 확장을 통해 특정 날짜의 시작 시간을 가져오는 기능
extension Date {
    // 해당 날짜의 시작 시간을 반환
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
