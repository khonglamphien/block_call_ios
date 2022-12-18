//
//  ContactViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 15/12/2022.
//

import UIKit
import Contacts
import ContactsUI

class ContactViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = self.getContactFromCNContact()
        tableView.reloadData()
            for contact in contacts {

                print("==========")
                
                print(contact.familyName)
                print(contact.givenName)
                print(contact.middleName)
                
            }
        setupView()
    }
    
    private func setupView() {
        tableView.registerCell(BlockTableViewCell.self)
    }
    
    func getContactFromCNContact() -> [CNContact] {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            CNContactNamePrefixKey,
            CNContactNicknameKey,
            CNContactNameSuffixKey,
            CNContactDepartmentNameKey
            ] as [Any]

        //Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {

            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)

            } catch {
                print("Error fetching results for container")
            }
        }

        return results
    }

}

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: BlockTableViewCell.self, forIndexPath: indexPath)
        let data = contacts[indexPath.row]
        cell.phoneNumberLabel.text = "\(data.familyName) \(data.givenName)"
        cell.nameLabel.text = ""
        cell.leftView.isHidden = false
        cell.nextButton.setImage(UIImage(named: "next_icon"), for: .normal)
        return cell
    }
    
}
