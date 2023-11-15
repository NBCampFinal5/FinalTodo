import UIKit

class SettingPageViewModel {
    var settingOtions: [[SettingOption]] = [
        [
            SettingOption(icon: "bell", title: "푸시 알림", showSwitch: false, isOn: false),
            SettingOption(icon: "paintbrush", title: "테마 컬러", showSwitch: false, isOn: false),
            SettingOption(icon: "lock", title: "잠금 모드", showSwitch: false, isOn: false)
        ],
        [
            SettingOption(icon: "person.circle", title: "프로필", showSwitch: false, isOn: false),
            SettingOption(icon: "info.circle", title: "앱정보", showSwitch: false, isOn: false),
            SettingOption(icon: "hand.raised", title: "개인정보처리방침", showSwitch: false, isOn: false)
        ]
    ]
}
