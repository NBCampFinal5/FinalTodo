import UIKit

struct SettingOption {
    let icon: String
    let title: String
    let showSwitch: Bool // 확장성을 위해 Bool 타입 이외에 방법으로 생각해보기, switch 버튼만 생각하지않기
    var isOn: Bool
    var detailText: String? // 선택된 날짜 또는 시간 정보를 저장
}
