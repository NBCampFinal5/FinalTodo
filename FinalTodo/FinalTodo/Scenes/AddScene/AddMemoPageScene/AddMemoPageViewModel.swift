import UIKit

class AddMemoPageViewModel {
    let coredataManager = CoreDataManager.shared
    var optionImageAry: [String] = [
        "날짜 및 시간알림",
        "위치 설정",
        "폴더 선택"
    ]
    var locationNotifySetting: String?
    var timeNotifySetting: String?
    var selectedDate: Date? // 사용자가 설정한 날짜를 저장하기 위한 속성
    var selectedTime: Date? // 사용자가 설정한 시간을 저장하기 위한 속성
    var tempDate: Date? // 사용자가 datePickerView에서 선택한 날짜를 임시로 저장하기 위한 속성
    var tempTime: Date? // 사용자가 timePickerView에서 선택한 시간을 임시로 저장하기 위한 속성
    var notificationIdentifier: String? // 알림 식별자를 저장하기 위한 변수
    var dateSet: Bool = false
    var timeSet: Bool = false
    var timeState: Observable<Bool> = Observable(false)
    var locateState: Observable<Bool> = Observable(false)

    var combinedDateTime: Date? {
        guard let selectedDate = selectedDate, let selectedTime = selectedTime else { return nil }
        return combineDateAndTime(date: selectedDate, time: selectedTime)
    }

    // 이 메소드는 선택된 날짜와 시간을 결합합니다.
    func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute

        return calendar.date(from: combinedComponents)!
    }
}
