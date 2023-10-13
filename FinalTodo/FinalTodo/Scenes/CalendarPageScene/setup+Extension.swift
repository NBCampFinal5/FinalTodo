import FSCalendar
import SnapKit
import UIKit

extension CalendarPageView {
    func setup() {
        backgroundColor = ColorManager.themeArray[0].backgroundColor
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
            // make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            // make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            // make.height.equalTo(Constant.screenHeight)
        }
    }
}

extension DdayPageViewController {
    func setup() {
        view.addSubview(ddayPickerView)

        ddayPickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
