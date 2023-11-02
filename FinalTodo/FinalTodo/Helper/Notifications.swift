import UIKit
import UserNotifications

class Notifications {
    static let shared = Notifications()

    // 앱에서 알림 권한을 요청하는 함수
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // 권한이 허용된 경우
            if granted {
                print("Notification permission granted.")
            }
            // 권한 요청에서 오류가 발생한 경우
            else if let error = error {
                print("Failed to request authorization: \(error.localizedDescription)")
            }
        }
    }

    // 선택한 시간 후에 알림을 예약하는 함수
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, soundEnabled: Bool, vibrationEnabled: Bool) {
        // 앱이 포그라운드에 있을 때만 "앱 실행 중 알림" 스위치의 상태를 확인
        if UIApplication.shared.applicationState == .active, !NotifySettingManager.shared.isNotificationEnabled {
            return
        }
        if !NotifySettingManager.shared.isNotificationEnabled { return } // 알림이 꺼져있다면 함수 종료
        // 알림의 내용을 설정
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        // 사운드가 활성화된 경우 기본 사운드를 설정
        if soundEnabled {
            content.sound = UNNotificationSound.default
        }
        // 진동이 활성화된 경우
        if vibrationEnabled {
            //
        }
        // 주어진 시간 후에 알림을 발생시키는 트리거를 생성
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        // 알림 요청을 생성하고 예약
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // 선택한 날짜에 알림을 예약하는 함수
    func scheduleNotificationAtDate(title: String, body: String, date: Date, identifier: String, soundEnabled: Bool, vibrationEnabled: Bool) {
        // 앱이 포그라운드에 있을 때만 "앱 실행 중 알림" 스위치의 상태를 확인
        if UIApplication.shared.applicationState == .active, !NotifySettingManager.shared.isNotificationEnabled {
            return
        }
        if !NotifySettingManager.shared.isNotificationEnabled { return } // 알림이 꺼져있다면 함수 종료
        // 알림의 내용을 설정
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        // 사운드가 활성화된 경우 기본 사운드를 설정
        if soundEnabled {
            content.sound = UNNotificationSound.default
        }
        // 진동이 활성화된 경우
        if vibrationEnabled {
            //
        }
        // 주어진 날짜에 알림을 발생시키는 트리거를 생성
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        // 알림 요청을 생성하고 예약
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    private init() {}
}
