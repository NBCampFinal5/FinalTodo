import Foundation

struct DdayDateModel {
    // 현재 연도부터 10년 후까지를 표시하기 위한 범위 설정
    let currentYear = Calendar.current.component(.year, from: Date())
    var years: [Int] { Array(1988...(currentYear + 10)) }
    let months: [Int] = Array(1...12)
    let days: [Int] = Array(1...31)
}

struct SettingOption {
    let icon: String
    var title: String
    let showSwitch: Bool
    var isOn: Bool
    var detailText: String? // 선택된 날짜 또는 시간 정보를 저장
}
