import FSCalendar
import UIKit

class CalendarPageView: UIView {
    // 날짜 형식을 변환하기 위한 dateFormatter
    let dateFormatter = DateFormatter()

    // 오늘 날짜로 돌아오는 버튼
    lazy var todayButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.backgroundColor = ColorManager.themeArray[0].pointColor01
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
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
        return calendar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
