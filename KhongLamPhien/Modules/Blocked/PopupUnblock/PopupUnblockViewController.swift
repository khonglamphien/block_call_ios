//
//  PopupUnblockViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 17/12/2022.
//

import UIKit
import CallKit

class PopupUnblockViewController: BaseViewController {
    
    enum TypeScreen {
        case block
        case unblock
        case report
    }

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    var unblockButton: () -> Void = {}
    var listBlock = [String]()
    var indexRemove = 0
    var numberBlock = ""
    var typeScreen: TypeScreen = .unblock
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        
        if typeScreen == .block {
            descriptionLabel.text = "are_you_sure_you_want_to_block".localized
            phoneNumberLabel.text = numberBlock
            cancelButton.setTitle("not_now".localized, for: .normal)
            blockButton.setTitle("block".localized, for: .normal)
            blockButton.backgroundColor = #colorLiteral(red: 0.8937208056, green: 0.3449975252, blue: 0.3410580158, alpha: 1)
            blockButton.setTitleColor(.white, for: .normal)
        } else if typeScreen == .report {
            descriptionLabel.text = "are_you_sure_you_want_to_report".localized
            phoneNumberLabel.text = numberBlock
            cancelButton.setTitle("cancle".localized, for: .normal)
            blockButton.setTitle("report".localized, for: .normal)
            blockButton.backgroundColor = #colorLiteral(red: 0.8937208056, green: 0.3449975252, blue: 0.3410580158, alpha: 1)
            blockButton.setTitleColor(.white, for: .normal)
        } else {
            descriptionLabel.text = "are_you_sure_you_want_to_unblock".localized
            phoneNumberLabel.text = listBlock[indexRemove]
        }
    }
    
    @IBAction func onSelectCancleButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onSelectUnblockButton(_ sender: Any) {
        if typeScreen == .block {
            numberBlock = numberBlock.removeFormat()
            if self.listBlock.contains(numberBlock) {
                self.dismiss(animated: true)
                return
            }
            self.listBlock.append(numberBlock)
            syncUD()
        } else if typeScreen == .report {
            viewModel.report(phoneNumber: numberBlock)
        } else {
            self.listBlock.remove(at: indexRemove)
            syncUD()
        }
    }
    
    func syncUD() {
        updateBlockedContactsList(contacts: listBlock)
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.callblock.healerpro.blockcall", completionHandler: { (error) -> Void in
            DispatchQueue.main.async {
                self.unblockButton()
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
    
}

extension PopupUnblockViewController {
    
    func addObserver() {
        viewModel.reportApiResponse.subscribe(onNext: {[weak self] (response) in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.responseSubject.subscribe(onNext: { (message) in
//            AlertManager.shared.showAlertDefault("", message: message.message, buttons: ["OK"], completed: nil)
//            Utils.hideLoadingIndicator()
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
}
