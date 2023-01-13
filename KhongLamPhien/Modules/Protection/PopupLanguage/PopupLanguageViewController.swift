//
//  PopupLanguageViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 13/01/2023.
//

import UIKit

class PopupLanguageViewController: BaseViewController {
    
    @IBOutlet weak var englishCheckImage: UIImageView!
    @IBOutlet weak var vietCheckImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        englishCheckImage.isHidden = Session.shared.laguage == "vi"
        vietCheckImage.isHidden = Session.shared.laguage == "en"
    }
    
    @IBAction func selectEnglishButton(_ sender: Any) {
        Session.shared.laguage = "en"
        dismiss(animated: true, completion: {
            Session.showHomeView()
        })
    }
    
    @IBAction func selectVietNamButton(_ sender: Any) {
        Session.shared.laguage = "vi"
        dismiss(animated: true, completion: {
            Session.showHomeView()
        })
    }
    
}
