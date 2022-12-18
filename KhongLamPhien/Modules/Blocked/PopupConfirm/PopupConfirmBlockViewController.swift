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
    
    var blockButton: () -> Void = {}
    var listBlock = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSelectCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onSelectBlockButton(_ sender: Any) {
        guard let number = phoneNumberTF.text, !number.isEmpty else {
            return
        }
//        let number = "0969794720"
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
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "anhnhn.KhongLamPhiens.CallBlock", completionHandler: { (error) -> Void in
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
        let defaults = UserDefaults(suiteName: "group.bcs.kuhb")
        defaults?.removeObject(forKey: "blockList")
        defaults?.set(contacts, forKey: "blockList")
        defaults?.synchronize()
    }
    
    func getBlockedContacts() -> [String] {
        let defaults = UserDefaults(suiteName: "group.bcs.kuhb")
        let blockedContacts = defaults?.value(forKey: "blockList") ?? []
        return blockedContacts as! [String]
    }
    
}
