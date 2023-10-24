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
        let tabBar = TabBarController()
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = UINavigationController(rootViewController: SignInPageViewController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("[SceneDelegate]:",#function)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("[SceneDelegate]:",#function)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("[SceneDelegate]:",#function)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("[SceneDelegate]:",#function)
        let manager = UserDefaultsManager()
        if manager.getLockIsOn() {
            guard let rootViewController = window?.rootViewController else { return }
            window?.rootViewController = LockScreenViewController(rootViewController: rootViewController)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("[SceneDelegate]:",#function)
    }
    

}

extension SceneDelegate {
    // MARK: - RootViewChangeMethod

    func changeRootVC(viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}

