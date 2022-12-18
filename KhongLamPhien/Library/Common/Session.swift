//
//  Session.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 08/12/2022.
//

import UIKit

class Session: NSObject {
    
    static let shared = Session()
    
    static func showHomeView() {
        let tabbarViewController = getHomeTabbar()
        if let window = UIApplication.shared.keyWindow {
            DispatchQueue.main.async {
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    let controller = UINavigationController(rootViewController: tabbarViewController)
                    controller.isNavigationBarHidden = true
                    window.rootViewController = controller
                }, completion: { _ in
                    
                })
            }
        }
    }
    
    static func getHomeTabbar() -> ESTabBarController {
       
        let tabbarViewController = ESTabBarController()
        
        let backgroundView = UIView()
        backgroundView.contentMode = .scaleToFill
        backgroundView.frame = tabbarViewController.tabBar.bounds
        backgroundView.backgroundColor = #colorLiteral(red: 0.3462057412, green: 0.3379235268, blue: 0.915156424, alpha: 1)
        if let window = UIApplication.shared.keyWindow {
            backgroundView.frame.size.height = 66 + window.safeAreaInsets.bottom
        }
        tabbarViewController.tabBar.addSubview(backgroundView)
        tabbarViewController.tabBar.clipsToBounds = true
        
        let homeViewController = UIStoryboard.storyBoard("HomeViewController").viewController(of: HomeViewController.self)
        let searchViewController = UIStoryboard.storyBoard("SearchViewController").viewController(of: SearchViewController.self)
        let blockedViewController =  UIStoryboard.storyBoard("BlockViewController").viewController(of: BlockViewController.self)
        let contactViewController = UIStoryboard.storyBoard("ContactViewController").viewController(of: ContactViewController.self)
        let protectionViewController = UIStoryboard.storyBoard("ProtectionViewController").viewController(of: ProtectionViewController.self)

        let esTabbarHome = ESTabBarItemContentView()
        esTabbarHome.highlightIconColor = .white
        esTabbarHome.highlightTextColor = .white
        let esTabbarSearch = ESTabBarItemContentView()
        esTabbarSearch.highlightIconColor = .white
        esTabbarSearch.highlightTextColor = .white
        let esTabbarBlocked = ESTabBarItemContentView()
        esTabbarBlocked.highlightIconColor = .white
        esTabbarBlocked.highlightTextColor = .white
        let esTabbarContact = ESTabBarItemContentView()
        esTabbarContact.highlightIconColor = .white
        esTabbarContact.highlightTextColor = .white
        let esTabbarProtection = ESTabBarItemContentView()
        esTabbarProtection.highlightIconColor = .white
        esTabbarProtection.highlightTextColor = .white
        
        homeViewController.tabBarItem = ESTabBarItem.init(esTabbarHome, title: "Home",
                                                image: UIImage(named: "home_icon"),
                                                selectedImage: UIImage(named: "home_icon"))
        searchViewController.tabBarItem = ESTabBarItem.init(esTabbarSearch, title: "Search",
                                                image: UIImage(named: "search_icon"),
                                                selectedImage: UIImage(named: "search_icon"))
        blockedViewController.tabBarItem = ESTabBarItem.init(esTabbarBlocked, title: "Blocked",
                                                      image: UIImage(named: "block_icon"),
                                                      selectedImage: UIImage(named: "block_icon"))
        contactViewController.tabBarItem = ESTabBarItem.init(esTabbarContact, title: "Contact",
                                                        image: UIImage(named: "contact_icon"),
                                                        selectedImage: UIImage(named: "contact_icon"))
        protectionViewController.tabBarItem = ESTabBarItem.init(esTabbarProtection, title: "Account",
                                                        image: UIImage(named: "shield_icon"),
                                                        selectedImage: UIImage(named: "shield_icon"))
        tabbarViewController.viewControllers = [homeViewController, searchViewController, blockedViewController, contactViewController, protectionViewController]
        return tabbarViewController
    }

}
