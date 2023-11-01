import FSCalendar
import SnapKit
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
        button.backgroundColor = .myPointColor
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

extension CalendarPageView {
    func setup() {
        backgroundColor = .systemBackground
        addSubview(calendar)
        addSubview(todayButton)

        todayButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.top).offset(22)
            make.trailing.equalTo(calendar.snp.trailing).offset(-15)
            make.width.equalTo(snp.width).multipliedBy(0.06)
            make.height.equalTo(todayButton.snp.width) // 버튼의 높이를 버튼의 넓이와 동일하게 설정
            // make.size.equalTo(CGSize(width: 30, height: 30))
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(Constant.defaultPadding)
            //make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-0)
            // make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            // make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            // make.height.equalTo(Constant.screenHeight)
        }
    }
}
