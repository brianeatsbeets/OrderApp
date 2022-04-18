//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var orderTabBarItem: UITabBarItem!
    
    // Set the bagde value on the order tab
    @objc func updateOrderBadge() {
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Add a notification observer to the order
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
        
        // Check if we have an NSUserActivity instance and pass it to configureScene(for:)
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            configureScene(for: userActivity)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // Fetch the MenuController's NSUserActivity instance
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    // Check if we have a stored order, and if so, restore it
    func configureScene(for userActivity: NSUserActivity) {
        if let restoredOrder = userActivity.order {
            MenuController.shared.order = restoredOrder
        }
        
        // Make sure that the environment is set as expected before restoring state
        guard
            let restorationController = StateRestorationController(userActivity: userActivity),
            let tabBarController = window?.rootViewController as? UITabBarController, tabBarController.viewControllers?.count == 2,
            let categoryTableViewController = (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? CategoryTableViewController
        else {
            return
        }
        
        // Initialize the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Determine which view controller should be presented based on stored state
        switch restorationController {
        case .categories:
            break
        case .menu(let category):
            // Instantiate a new MenuTableViewController and pass it the stored category
            let menuTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { (coder) in
                return MenuTableViewController(coder: coder, category: category)
            }
            
            // Push the view controller
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
        case .menuItemDetail(let menuItem):
            // Instantiate a new MenuTableViewController and pass it the stored category
            let menuTableViewController = storyboard.instantiateViewController(identifier: StateRestorationController.Identifier.menu.rawValue) { (coder) in
                return MenuTableViewController(coder: coder, category: menuItem.category)
            }
            
            // Instantiate a new MenuItemDetailViewController and pass it the stored menuItem
            let menuItemDetailViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { (coder) in
                return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
            }
            
            // Push both view controllers in order
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
            categoryTableViewController.navigationController?.pushViewController(menuItemDetailViewController, animated: true)
        case .order:
            // Set the selected tab bar view controller
            tabBarController.selectedIndex = 1
        }
    }


}

