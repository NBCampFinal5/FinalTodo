import FSCalendar
import SnapKit
import UIKit

extension CalendarPageViewController {
    func setup() {
        view.addSubview(calendar)
        view.addSubview(todayButton)

        todayButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.top).offset(22)
            make.trailing.equalTo(calendar.snp.trailing).offset(-15)
            make.width.equalTo(view.snp.width).multipliedBy(0.06)
            make.height.equalTo(todayButton.snp.width) // 버튼의 높이를 버튼의 넓이와 동일하게 설정
            // make.size.equalTo(CGSize(width: 30, height: 30))
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            // make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constant.defaultPadding)
            // make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            // make.height.equalTo(Constant.screenHeight)
        }
    }
}
