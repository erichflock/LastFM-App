//
//  TabBarController.swift
//  LastFM-App
//
//  Created by Erich Flock on 27.02.21.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBarAppearance()
        addViewControllersToTabBar()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
    }
    
    private func addViewControllersToTabBar() {
        viewControllers = [createNavigationController(for: UIViewController(), title: "Home", image: UIImage(systemName: "music.note.house.fill")), createNavigationController(for: UIViewController(), title: "Search", image: UIImage(systemName: "magnifyingglass.circle.fill"))]
    }
    
    private func createNavigationController(for viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
}
