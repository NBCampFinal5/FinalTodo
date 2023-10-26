import Foundation

class NotifySettingManager {
    
    static let shared = NotifySettingManager()
    
    private let userDefaults = UserDefaults.standard
    
    // 앱 실행 중 알림 설정. UserDefaults에서 해당 키의 값을 가져오거나 저장
    var isNotificationEnabled: Bool {
        get {
            // "isNotificationEnabled" 키의 값을 반환. 값이 없으면 false를 반환
            return userDefaults.bool(forKey: "isNotificationEnabled")
        }
        set {
            // "isNotificationEnabled" 키에 새로운 값을 저장
            userDefaults.set(newValue, forKey: "isNotificationEnabled")
        }
    }
    
    // 앱 실행 중 사운드 설정. UserDefaults에서 해당 키의 값을 가져오거나 저장
    var isSoundEnabled: Bool {
        get {
            // "isSoundEnabled" 키의 값을 반환. 값이 없으면 false를 반환
            return userDefaults.bool(forKey: "isSoundEnabled")
        }
        set {
            // "isSoundEnabled" 키에 새로운 값을 저장
            userDefaults.set(newValue, forKey: "isSoundEnabled")
        }
    }
    
    // 앱 실행 중 진동 설정. UserDefaults에서 해당 키의 값을 가져오거나 저장
    var isVibrationEnabled: Bool {
        get {
            // "isVibrationEnabled" 키의 값을 반환. 값이 없으면 false를 반환
            return userDefaults.bool(forKey: "isVibrationEnabled")
        }
        set {
            // "isVibrationEnabled" 키에 새로운 값을 저장
            userDefaults.set(newValue, forKey: "isVibrationEnabled")
        }
    }
    
    private init() {}
}
