//
//  LaunchViewController.swift
//  KhongLamPhien
//
//  Created by Nguyen Anh on 09/12/2022.
//

import UIKit

class LaunchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNextView()
    }
    
    func loadNextView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Session.showHomeView()
        }
    }

}
