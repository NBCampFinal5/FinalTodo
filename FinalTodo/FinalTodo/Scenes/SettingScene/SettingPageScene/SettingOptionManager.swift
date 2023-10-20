import UIKit

class SettingOptionManager {
    var SettingOptions: [[SettingOption]] = []

    // 배열의 index[n]에 섹션[n]에 들어갈 세팅옵션 데이터 등록, 추후 네트워킹 코드로 변환 가능
    // 사용할 뷰컨트롤러에서 makeSettingOptions(), getSettingOptions() 데이터를 만들고 받아오는 두 함수 호출 필수!
    func makeSettingOptions() {
        SettingOptions = [
            [
                SettingOption(icon: "bell", title: "푸시 알림", showSwitch: false),
                SettingOption(icon: "paintbrush", title: "테마 컬러", showSwitch: false),
                SettingOption(icon: "lock", title: "잠금모드", showSwitch: false)
            ],
            [
                SettingOption(icon: "person.circle", title: "프로필", showSwitch: false),
                SettingOption(icon: "arrow.right.circle", title: "로그아웃", showSwitch: false)
            ]
        ]
    }

    func getSettingOptions() -> [[SettingOption]] {
        return SettingOptions
    }
}
