//
//  TabBarController.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 2023/10/10.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

private extension TabBarController {
    func setUp() {
        let mainVC = UINavigationController(rootViewController: MainPageViewController())
        mainVC.tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        let calendarVC = UINavigationController(rootViewController: CalendarPageViewController())
        calendarVC.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "sparkle.magnifyingglass")
        )
        let rewardVC = UINavigationController(rootViewController: RewardPageViewController())
        rewardVC.tabBarItem = UITabBarItem(
            title: "Reward",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "sparkle.magnifyingglass")
        )
        let settingVC = UINavigationController(rootViewController: SettingPageViewController())
        settingVC.tabBarItem = UITabBarItem(
            title: "Setting",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "sparkle.magnifyingglass")
        )
        
        
        viewControllers = [mainVC, calendarVC, rewardVC, settingVC]
        tabBar.tintColor = .systemPink
    }
}
