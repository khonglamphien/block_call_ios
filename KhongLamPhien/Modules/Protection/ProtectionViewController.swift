//
//  ProtectionViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 17/12/2022.
//

import UIKit

class ProtectionViewController: BaseViewController {

    @IBOutlet weak var regionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let countryCode = Locale.current.regionCode
        regionLabel.text = countryName(from: countryCode ?? "")
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }

    @IBAction func onSelectContactButton(_ sender: Any) {
        let webviewVC = UIStoryboard.storyBoard("WebViewViewController").viewController(of: WebViewViewController.self)
        webviewVC.typeScreen = .contact
        navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @IBAction func onSelectPrivacyButton(_ sender: Any) {
        let webviewVC = UIStoryboard.storyBoard("WebViewViewController").viewController(of: WebViewViewController.self)
        webviewVC.typeScreen = .privacy
        navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @IBAction func onSelectTermsButton(_ sender: Any) {
        let webviewVC = UIStoryboard.storyBoard("WebViewViewController").viewController(of: WebViewViewController.self)
        webviewVC.typeScreen = .terms
        navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @IBAction func shareFaceBook(_ sender: Any) {
    }
    
    @IBAction func shareApp(_ sender: Any) {
    }
    
}
