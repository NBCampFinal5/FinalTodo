import UIKit

class AddMemoPageViewModel {
    let optionImageAry: [String] = [
        "날짜 및 시간알림",
        "위치 설정",
        "폴더 선택"
    ]

    var selectedDate: Date? // 사용자가 설정한 날짜를 저장하기 위한 프로퍼티
    var selectedTime: Date? //     // 사용자가 설정한 시간을 저장하기 위한 프로퍼티
    var tempDate: Date? // 사용자가 datePickerView에서 선택한 날짜를 임시로 저장하기 위한 프로퍼티
    var tempTime: Date? // 사용자가 timePickerView에서 선택한 시간을 임시로 저장하기 위한 프로퍼티
    var notificationIdentifier: String? // 알림을 설정할 때 사용되는 고유 식별자를 저장하기 위한 프로퍼티
    var dateSet: Bool = false // 사용자가 날짜를 설정했는지 여부를 나타내는 변수
    var timeSet: Bool = false // 사용자가 시간을 설정했는지 여부를 나타내는 변수
    var timeState: Observable<Bool> = Observable(false) // 시간 설정 상태를 관찰하기 위한 Observable 프로퍼티
    var locateState: Observable<Bool> = Observable(false) // 위치 설정 상태를 관찰하기 위한 Observable 프로퍼티
}
