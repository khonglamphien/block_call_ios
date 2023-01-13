//
//  Session.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 08/12/2022.
//

import UIKit

class Session: NSObject {
    
    static let shared = Session()
    
    var laguage: String {
        get {
            return UserDefaults.standard.string(forKey: "language") ?? "en"
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "language")
        }
    }
    
    static func showHomeView(_ indexTab: Int = 0) {
        let tabbarViewController = getHomeTabbar(indexTab)
        if let window = UIApplication.shared.keyWindow {
            DispatchQueue.main.async {
                if indexTab == 0 {
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                        let controller = UINavigationController(rootViewController: tabbarViewController)
                        controller.isNavigationBarHidden = true
                        window.rootViewController = controller
                    }, completion: { _ in
                        
                    })
                } else {
                    let controller = UINavigationController(rootViewController: tabbarViewController)
                    controller.isNavigationBarHidden = true
                    window.rootViewController = controller
                }
            }
        }
    }
    
    static func getHomeTabbar(_ indexSelect: Int = 0) -> ESTabBarController {
       
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
        
        homeViewController.tabBarItem = ESTabBarItem.init(esTabbarHome, title: "home".localized,
                                                image: UIImage(named: "home_icon"),
                                                selectedImage: UIImage(named: "home_icon"))
        searchViewController.tabBarItem = ESTabBarItem.init(esTabbarSearch, title: "search".localized,
                                                image: UIImage(named: "search_icon"),
                                                selectedImage: UIImage(named: "search_icon"))
        blockedViewController.tabBarItem = ESTabBarItem.init(esTabbarBlocked, title: "blocked".localized,
                                                      image: UIImage(named: "block_icon"),
                                                      selectedImage: UIImage(named: "block_icon"))
        contactViewController.tabBarItem = ESTabBarItem.init(esTabbarContact, title: "contact".localized,
                                                        image: UIImage(named: "contact_icon"),
                                                        selectedImage: UIImage(named: "contact_icon"))
        protectionViewController.tabBarItem = ESTabBarItem.init(esTabbarProtection, title: "account".localized,
                                                        image: UIImage(named: "shield_icon"),
                                                        selectedImage: UIImage(named: "shield_icon"))
        tabbarViewController.viewControllers = [homeViewController, searchViewController, blockedViewController, contactViewController, protectionViewController]
        tabbarViewController.selectedIndex = indexSelect
        return tabbarViewController
    }

}
