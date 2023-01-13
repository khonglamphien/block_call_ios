//
//  ContactDetailViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 19/12/2022.
//

import UIKit
import Contacts
import ContactsUI
import PopupDialog

class ContactDetailViewController: BaseViewController {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    var contact: CNContact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    @IBAction func onSelectBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        reportButton.setTitle("report_number".localized, for: .normal)
        shareButton.setTitle("share_contact".localized, for: .normal)
        blockButton.setTitle("block".localized, for: .normal)
        guard let data = contact else {
            return
        }
        nickNameLabel.text = "\(data.familyName.prefix(1))\(data.givenName.prefix(1))"
        nameLabel.text = "\(data.familyName) \(data.givenName)"
        phoneNumber.text = data.phoneNumbers.first?.value.stringValue ?? ""
    }
    
    @IBAction func onSelectReportButton(_ sender: Any) {
        let alertViewController = UIStoryboard.storyBoard("PopupUnblockViewController").viewController(of: PopupUnblockViewController.self)
        alertViewController.numberBlock = contact?.phoneNumbers.first?.value.stringValue ?? ""
        alertViewController.typeScreen = .report
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
    @IBAction func onSelectShareContactButton(_ sender: Any) {
        let text = contact?.phoneNumbers.first?.value.stringValue ?? ""
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, .copyToPasteboard ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
//        guard let contact = contact else {
//            return
//        }
//
//        let cacheDirectory = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
//
//            let fileLocation = cacheDirectory.appendingPathComponent("\(CNContactFormatter().string(from: contact)!).vcf")
//
//            let contactData = try! CNContactVCardSerialization.data(with: [contact])
//            do {
//                _ = try contactData.write(to: fileLocation, options: .atomic)
//            } catch let error {
//                print(error)
//            }
//
//        let activityVC = UIActivityViewController(activityItems: [fileLocation], applicationActivities: nil)
//        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func onSelectBlockButton(_ sender: Any) {
        let alertViewController = UIStoryboard.storyBoard("PopupUnblockViewController").viewController(of: PopupUnblockViewController.self)
        alertViewController.listBlock = getBlockedContacts()
        alertViewController.numberBlock = contact?.phoneNumbers.first?.value.stringValue ?? ""
        alertViewController.typeScreen = .block
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
    func getBlockedContacts() -> [String] {
        let defaults = UserDefaults(suiteName: "group.bcs.kuhb")
        let blockedContacts = defaults?.value(forKey: "blockList") ?? []
        return blockedContacts as! [String]
    }
    
}
