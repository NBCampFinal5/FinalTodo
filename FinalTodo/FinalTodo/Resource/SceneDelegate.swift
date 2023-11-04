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
        let signInVC = UINavigationController(rootViewController: SignInPageViewController())
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = signInVC
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
        let manager = UserDefaultsManager()
        let loginManager = LoginManager()
        
        if loginManager.isLogin() {
            if manager.getLockIsOn() {
                window?.rootViewController = LockScreenViewController(rootViewController: TabBarController())
            } else {
                window?.rootViewController = TabBarController()
            }
        } else {
            window?.rootViewController = UINavigationController(rootViewController: SignInPageViewController())
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[SceneDelegate]:", #function)
        func applicationDidEnterBackground(_ application: UIApplication) {
            FirebaseDBManager.shared.updateFirebaseWithCoredata { error in
                if let error = error {
                    print("Firebase update error: \(error.localizedDescription)")
                } else {
                    print("Firebase update success")
                }
            }
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
