//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit
import UserNotifications

class RootViewController: UIViewController {
    
    private(set) static var instance: RootViewController? = nil
    
    let splashScreen: SplashScreenViewController = {
        return SplashScreenViewController(nibName: nil, bundle: nil)
    }()
    
    lazy var mainTabBar: MenuTabBarController? = {
        return MenuTabBarController()
    }()
    
    lazy var authNavigation: AuthNavigationController? = {
        return createAuthNavigationController
    }()
    
    var createAuthNavigationController: AuthNavigationController {
        let loginViewController = LoginViewController(nibName: nil, bundle: nil)
        let navigationController = AuthNavigationController(rootViewController: loginViewController)
        loginViewController.presenter = LoginPresenter(view: loginViewController)
        return navigationController
    }
    
    var currentViewController: UIViewController? = nil {
        didSet {
            oldValue?.removeFromParentViewController()
            oldValue?.view.removeFromSuperview()
            
            guard let currentViewController = currentViewController else { return }
            self.addChildViewController(currentViewController)
            currentViewController.view.frame = self.view.bounds
            self.view.addSubview(currentViewController.view)
            currentViewController.didMove(toParentViewController: self)
        }
    }
    
    override func viewDidLoad() {
        UNUserNotificationCenter.current().delegate = self
    
        currentViewController = splashScreen
        splashScreen.completion = { [weak self] in
            let token: String? = StorageHelper.loadObjectForKey(.accessToken)
            let isAuthorized = !(token ?? "").isEmpty
            isAuthorized ? self?.setMainView() : self?.setAuthView()
        }
    }
    
    func setAuthView() {
        currentViewController = authNavigation
        mainTabBar = nil
        mainTabBar = MenuTabBarController()
    }
    
    func setMainView() {
        currentViewController = mainTabBar
        authNavigation = nil
        authNavigation = createAuthNavigationController
    }
    
    override func loadView() {
        RootViewController.instance = self
        super.loadView()
    }
}

extension RootViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps!["alert"] as? [String: Any]
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
