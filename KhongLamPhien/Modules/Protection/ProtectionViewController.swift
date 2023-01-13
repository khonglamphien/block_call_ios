//
//  ProtectionViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 17/12/2022.
//

import UIKit
import PopupDialog

class ProtectionViewController: BaseViewController {

    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageTitleLabel: UILabel!
    @IBOutlet weak var regionTitleLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var languageValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let countryCode = Locale.current.regionCode
        regionLabel.text = countryName(from: countryCode ?? "")
        
        titleLabel.text = "account".localized
        languageTitleLabel.text = "language".localized
        regionTitleLabel.text = "region".localized
        contactButton.setTitle("contact_setting".localized, for: .normal)
        privacyButton.setTitle("privacy_policy".localized, for: .normal)
        termButton.setTitle("terms_of_user".localized, for: .normal)
        shareButton.setTitle("share".localized, for: .normal)
        languageValueLabel.text = Session.shared.laguage == "en" ? "English" : "Việt Nam"
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
        let URLstring =  String(format:"https://callblockpro.page.link/app")
        let urlToShare = URL(string:URLstring)
        let title = "Block Broker"
        let activityViewController = UIActivityViewController(
            activityItems: [title,urlToShare!],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController,animated: true,completion: nil)
    }
    
    @IBAction func changeLanguageButton(_ sender: Any) {
        let alertViewController = UIStoryboard.storyBoard("PopupLanguageViewController").viewController(of: PopupLanguageViewController.self)
        
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
}
