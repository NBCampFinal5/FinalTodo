import UIKit

class AddMemoPageViewModel {
    let optionImageAry: [String] = [
        "날짜 설정",
        "알림 설정",
        "위치 설정"
    ]
    
    var selectedDate: Date?
    var timeState: Observable<Bool> = Observable(false)
    var locateState: Observable<Bool> = Observable(false)
}
