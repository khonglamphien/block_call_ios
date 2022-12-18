//
//  BlockViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 09/12/2022.
//

import UIKit
import CallKit
import PopupDialog

class BlockViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var listBlock = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //syncUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listBlock = getBlockedContacts()
        tableView.reloadData()
    }
    
    private func setupView() {
        tableView.registerCell(BlockTableViewCell.self)
    }
    
    func syncUD() {
        //save blocklist in userdefaults
        updateBlockedContactsList(contacts: listBlock)
        print("abc123=====llddđ", getBlockedContacts())
        //reload extension to update blocklist entries
        
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "anhnhn.KhongLamPhiens.CallBlock", completionHandler: { (error) -> Void in
            print( "======seeee")
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

    @IBAction func onSelectBlockButton(_ sender: Any) {
        let alertViewController = UIStoryboard.storyBoard("PopupConfirmBlockViewController").viewController(of: PopupConfirmBlockViewController.self)
        alertViewController.listBlock = listBlock
        alertViewController.blockButton = {
            self.listBlock = self.getBlockedContacts()
            self.tableView.reloadData()
        }
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
}

extension BlockViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBlock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: BlockTableViewCell.self, forIndexPath: indexPath)
        cell.phoneNumberLabel.text = listBlock[indexPath.row]
        cell.nameLabel.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertViewController = UIStoryboard.storyBoard("PopupUnblockViewController").viewController(of: PopupUnblockViewController.self)
        alertViewController.listBlock = listBlock
        alertViewController.indexRemove = indexPath.row
        alertViewController.unblockButton = {
            self.listBlock = self.getBlockedContacts()
            self.tableView.reloadData()
        }
        let dialog = PopupDialog(viewController: alertViewController)
        present(dialog, animated: true, completion: nil)
    }
    
}

extension String {
    
    func removeFormat() -> String {
        var mobileNumber: String = self
        mobileNumber = mobileNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        mobileNumber = mobileNumber.trimmingCharacters(in: CharacterSet.symbols)
        mobileNumber = mobileNumber.trimmingCharacters(in: CharacterSet.punctuationCharacters)
        mobileNumber = mobileNumber.trimmingCharacters(in: CharacterSet.controlCharacters)
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "\u{00a0}", with: "")
        return mobileNumber
    }
    
}
