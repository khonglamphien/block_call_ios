//
//  PopupConfirmBlockViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 17/12/2022.
//

import UIKit
import CallKit

class PopupConfirmBlockViewController: BaseViewController {

    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var blockTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var blockTitleButton: UIButton!
    
    var blockButton: () -> Void = {}
    var listBlock = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blockTitleLabel.text = "block_phone_number".localized
        descriptionLabel.text = "enter_the_phone_number".localized
        errorLabel.text = "error_enter_number".localized
        closeButton.setTitle("close".localized, for: .normal)
        blockTitleButton.setTitle("block".localized, for: .normal)
    }

    @IBAction func onSelectCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onSelectBlockButton(_ sender: Any) {
        guard let number = phoneNumberTF.text, !number.isEmpty else {
            return
        }
        if !number.hasPrefix("+") {
            errorLabel.isHidden = false
            return
        }
        errorLabel.isHidden = true
        var phoneNumber = number
        phoneNumber = phoneNumber.removeFormat()
        if self.listBlock.contains(phoneNumber) {
            return
        }
        self.listBlock.append(phoneNumber)
        syncUD()
    }
    
    func syncUD() {
        updateBlockedContactsList(contacts: listBlock)
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.callblock.healerpro.blockcall", completionHandler: { (error) -> Void in
            DispatchQueue.main.async {
                self.blockButton()
                self.dismiss(animated: true)
            }
            if let error = error {
                print( "======", error.localizedDescription)
            }
        })
    }
    
    func updateBlockedContactsList(contacts: [String]) {
        let defaults = UserDefaults(suiteName: "group.com.callblock.pro")
        defaults?.removeObject(forKey: "blockList")
        defaults?.set(contacts, forKey: "blockList")
        defaults?.synchronize()
    }
    
    func getBlockedContacts() -> [String] {
        let defaults = UserDefaults(suiteName: "group.com.callblock.pro")
        let blockedContacts = defaults?.value(forKey: "blockList") ?? []
        return blockedContacts as! [String]
    }
    
}
