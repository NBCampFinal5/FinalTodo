import FSCalendar
import SnapKit
import UIKit

class CalendarPageView: UIView {
    // 날짜 형식을 변환하기 위한 dateFormatter
    let dateFormatter = DateFormatter()

    // 오늘 날짜로 돌아오는 버튼
    lazy var todayButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .label
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
        calendar.appearance.weekdayTextColor = .myPointColor
        calendar.appearance.headerTitleColor = .myPointColor
        return calendar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarPageView {
    func setUp() {
        backgroundColor = .secondarySystemBackground
        addSubview(calendar)
        addSubview(todayButton)

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        todayButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.top).offset(screenHeight * 0.03)
            make.trailing.equalTo(calendar.snp.trailing).offset(-screenWidth * 0.03)
            make.width.equalTo(screenWidth * 0.05)
            make.height.equalTo(todayButton.snp.width) // 버튼의 높이를 버튼의 넓이와 동일하게 설정
            // make.size.equalTo(CGSize(width: 30, height: 30))
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(screenHeight * 0.01)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(screenWidth * 0.04)
            make.bottom.equalTo(safeAreaLayoutGuide)

            // make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            // make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            // make.height.equalTo(Constant.screenHeight)
        }
    }
}
