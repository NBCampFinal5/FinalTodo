//
//  AppDelegate.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import CoreData
import FirebaseCore
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { UNUserNotificationCenter.current().delegate = self
        
        // 권한 요청 코드 추가
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("알림 권한 허용됨!")
            } else {
                print("알림 권한 거부됨!")
            }
        }
        
        FirebaseApp.configure()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let manager = UserDefaultsManager()
        let loginManager = LoginManager()
        if !manager.getIsAutoLogin() {
            loginManager.signOut()
        }
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserDataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("🟡Unresolved error \(error), \(error.userInfo)🟡")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("🟡Unresolved error \(nserror), \(nserror.userInfo)🟡")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.banner, .sound, .badge]) // 원하는 알림 옵션을 선택합니다.
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void)
//    {
//        let userInfo = response.notification.request.content.userInfo
//        if let memoId = userInfo["memoId"] as? String {
//            // 현재 활성화된 scene을 찾습니다.
//            guard let sceneDelegate = UIApplication.shared.connectedScenes
//                .first(where: { $0.activationState == .foregroundActive })?
//                .delegate as? SceneDelegate
//            else {
//                completionHandler()
//                return
//            }
//
//            // 메모 ID를 사용하여 코어 데이터에서 해당 메모의 데이터를 가져옵니다.
//            let memos = CoreDataManager.shared.getMemos()
//            if let targetMemo = memos.first(where: { $0.id == memoId }) {
//                // scene의 window에 접근합니다.
//                if let navigationController = sceneDelegate.window?.rootViewController as? UINavigationController {
//                    let memoDetailVC = MemoViewController() // 메모 상세 화면 뷰 컨트롤러 인스턴스 생성
//                    memoDetailVC.loadMemoData(memo: targetMemo) // 가져온 메모 데이터를 뷰 컨트롤러에 전달
//                    navigationController.pushViewController(memoDetailVC, animated: true)
//                }
//            }
//        }
//        completionHandler()
//    }
}
