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
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
    }
    
    private func addViewControllersToTabBar() {
        viewControllers = [createNavigationController(for: LibraryViewController(), image: UIImage(systemName: "music.note.house.fill")), createNavigationController(for: SearchTableViewController(), image: UIImage(systemName: "magnifyingglass.circle.fill"))]
    }
    
    private func createNavigationController(for viewController: UIViewController, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
}
