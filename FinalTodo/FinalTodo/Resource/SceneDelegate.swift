//
//  SceneDelegate.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        print("[SceneDelegate]:", #function)
        let loginManager = LoginManager()
        let userDefaultManager = UserDefaultsManager()
        let signInVC = UINavigationController(rootViewController: SignInPageViewController())
        let tabBarVC = TabBarController()
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
        if loginManager.isLogin() {
            if userDefaultManager.getIsAutoLogin() {
                if userDefaultManager.getLockIsOn() {
                    window?.rootViewController = LockScreenViewController(rootViewController: tabBarVC)
                } else {
                    window?.rootViewController = tabBarVC
                }
            } else {
                window?.rootViewController = signInVC
            }
        } else {
            window?.rootViewController = signInVC
        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
        let coredataMnager = CoreDataManager.shared
        UIColor.myPointColor = UIColor(hex: coredataMnager.getUser().themeColor)
        guard let rootVC = window?.rootViewController else { return }
        window?.rootViewController = rootVC
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
        let manager = UserDefaultsManager()
        let loginManager = LoginManager()
        let coredataMnager = CoreDataManager.shared
        
        FirebaseDBManager.shared.updateFirebaseWithCoredata { error in
            if let error = error {
                print("Firebase update error: \(error.localizedDescription)")
            } else {
                print("Firebase update success")
            }
        }
        guard let rootVC = window?.rootViewController else { return }
        
        if coredataMnager.getUser().id == "error" {
            loginManager.signOut()
        }
        
        if loginManager.isLogin() {
            if manager.getLockIsOn() {
                window?.rootViewController = LockScreenViewController(rootViewController: rootVC)
            } else {
                window?.rootViewController = rootVC
            }
        } else {
            window?.rootViewController = UINavigationController(rootViewController: SignInPageViewController())
        }
        
    }
}


extension SceneDelegate {
    // MARK: - RootViewChangeMethod
    
    func changeRootVC(viewController: UIViewController, animated: Bool) {
        guard let window = window else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}
