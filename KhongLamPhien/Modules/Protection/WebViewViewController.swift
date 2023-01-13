//
//  WebViewViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 21/12/2022.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {
    
    enum TypeWeb {
        case contact
        case terms
        case privacy
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myWebView: WKWebView!
    
    var typeScreen: TypeWeb = .contact
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch typeScreen {
            case .contact:
                titleLabel.text = "contact_setting".localized
                let myURL = URL(string:"https://khonglamphien.com/")
                let myRequest = URLRequest(url: myURL!)
                myWebView.load(myRequest)
            case .terms:
                titleLabel.text = "terms_of_user".localized
                let myURL = URL(string:"https://khonglamphien.com/")
                let myRequest = URLRequest(url: myURL!)
                myWebView.load(myRequest)
            case .privacy:
                titleLabel.text = "privacy_policy".localized
                let localfilePath = Bundle.main.url(forResource: "terms", withExtension: "rtf")
                let myRequest = URLRequest(url: localfilePath!)
                myWebView.load(myRequest)
                
        }
        
    }
    
    @IBAction func onSelectBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
