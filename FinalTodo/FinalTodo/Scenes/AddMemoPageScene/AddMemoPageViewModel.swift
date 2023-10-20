import UIKit

class AddMemoPageViewModel {
    let optionImageAry: [String] = [
        "날짜 설정",
        "알림 설정",
        "위치 설정"
    ]
    
    var selectedDate: Date? // 사용자가 설정한 날짜를 저장하기 위한 속성
    var selectedTime: Date? // 사용자가 설정한 시간을 저장하기 위한 속성
    var tempDate: Date? // 사용자가 datePickerView에서 선택한 날짜를 임시로 저장하기 위한 속성
    var tempTime: Date? // 사용자가 timePickerView에서 선택한 시간을 임시로 저장하기 위한 속성
    var timeState: Observable<Bool> = Observable(false)
    var locateState: Observable<Bool> = Observable(false)
}
