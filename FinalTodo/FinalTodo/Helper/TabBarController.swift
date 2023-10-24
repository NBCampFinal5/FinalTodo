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
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.badge.clock")
        )
        let rewardVC = UINavigationController(rootViewController: RewardPageViewController())
        rewardVC.tabBarItem = UITabBarItem(
            title: "Reward",
            image: UIImage(systemName: "pencil.circle"),
            selectedImage: UIImage(systemName: "pencil.circle.fill")
        )
        let settingVC = UINavigationController(rootViewController: SettingPageViewController())
        settingVC.tabBarItem = UITabBarItem(
            title: "Setting",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        viewControllers = [mainVC, calendarVC, rewardVC, settingVC]
        tabBar.tintColor = .systemPink
        tabBar.barTintColor = ColorManager.themeArray[0].backgroundColor // 탭바 배경색 설정
        tabBar.shadowImage = UIImage() // 탭바 경계선 없애기
        tabBar.backgroundImage = UIImage() // 탭바 경계선 없애기
    }
}
